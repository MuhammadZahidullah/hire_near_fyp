import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_near_fyp/features/home/popular_workers/models/category_worker_model.dart';

/// Persists each customer's favorites under:
///   users/{uid}/favorites/{workerId}
///
/// Stored fields:
///   - workerId  (String)
///   - createdAt (Timestamp)
///
/// The full CategoryWorkerModel list is kept in-memory for instant UI reads.
/// Firestore is the source-of-truth that survives app restarts.
class FavoritesProvider extends ChangeNotifier {
  // ─── Firestore ────────────────────────────────────────────────────────────
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── State ────────────────────────────────────────────────────────────────
  /// Worker IDs the current user has favourited (fast O(1) lookup).
  final Set<String> _favoriteIds = {};

  /// Full model list shown in the Favorites UI tab.
  final List<CategoryWorkerModel> _favorites = [];

  /// UID of the user whose favorites are currently loaded; null when logged out.
  String? _loadedUid;

  bool _isLoading = false;

  // ─── Getters ──────────────────────────────────────────────────────────────
  List<CategoryWorkerModel> get favorites => List.unmodifiable(_favorites);
  int get favoritesCount => _favorites.length;
  bool get isLoading => _isLoading;

  /// Returns true if [workerId] is in this user's favorites.
  /// Accepts null/empty safely (returns false).
  bool isFavorite(String? workerId) {
    if (workerId == null || workerId.isEmpty) return false;
    return _favoriteIds.contains(workerId);
  }

  // ─── Load ─────────────────────────────────────────────────────────────────

  /// Call this after a successful login or on app-startup when a session is
  /// restored.  Idempotent — skips the network fetch if already loaded for
  /// the same [uid].
  Future<void> loadForUser(
    String uid, {
    /// Optional: pass the currently known list of workers so the full
    /// CategoryWorkerModel can be reconstructed from Firestore IDs.
    List<CategoryWorkerModel> allWorkers = const [],
  }) async {
    if (_loadedUid == uid) return; // already loaded for this user
    await _load(uid, allWorkers: allWorkers);
  }

  Future<void> _load(
    String uid, {
    List<CategoryWorkerModel> allWorkers = const [],
  }) async {
    _isLoading = true;
    _favoriteIds.clear();
    _favorites.clear();
    _loadedUid = uid;
    notifyListeners();

    try {
      final snap = await _db
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .orderBy('createdAt', descending: true)
          .get();

      for (final doc in snap.docs) {
        final wid = doc.id; // document ID == workerId
        _favoriteIds.add(wid);

        // Reconstruct the model from the in-memory worker list when available.
        final match = allWorkers.where((w) => w.workerId == wid);
        if (match.isNotEmpty) {
          _favorites.add(match.first);
        }
        // If not found (e.g. worker removed), we silently skip — Req 11.
      }
    } catch (e) {
      debugPrint('[FavoritesProvider] load error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Toggle ───────────────────────────────────────────────────────────────

  /// Adds or removes [worker] from favorites, both locally and in Firestore.
  Future<void> toggleFavorite(CategoryWorkerModel worker) async {
    final wid = worker.workerId;
    if (wid == null || wid.isEmpty) {
      // Req 11: skip workers without a valid Firebase UID.
      debugPrint('[FavoritesProvider] toggleFavorite: workerId is null/empty, skipping.');
      return;
    }

    if (_loadedUid == null) {
      debugPrint('[FavoritesProvider] toggleFavorite: no user loaded, skipping.');
      return;
    }

    if (isFavorite(wid)) {
      // ── Remove ────────────────────────────────────────────────────────────
      _favoriteIds.remove(wid);
      _favorites.removeWhere((w) => w.workerId == wid);
      notifyListeners();

      try {
        await _db
            .collection('users')
            .doc(_loadedUid!)
            .collection('favorites')
            .doc(wid)
            .delete();
      } catch (e) {
        // Roll-back optimistic update
        debugPrint('[FavoritesProvider] remove error, rolling back: $e');
        _favoriteIds.add(wid);
        _favorites.add(worker);
        notifyListeners();
      }
    } else {
      // ── Add (Req 10: no-op if already present) ────────────────────────────
      _favoriteIds.add(wid);
      _favorites.insert(0, worker);
      notifyListeners();

      try {
        await _db
            .collection('users')
            .doc(_loadedUid!)
            .collection('favorites')
            .doc(wid)
            .set({
          'workerId': wid,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)); // merge: true prevents accidental overwrites
      } catch (e) {
        // Roll-back optimistic update
        debugPrint('[FavoritesProvider] add error, rolling back: $e');
        _favoriteIds.remove(wid);
        _favorites.removeWhere((w) => w.workerId == wid);
        notifyListeners();
      }
    }
  }

  // ─── Clear ────────────────────────────────────────────────────────────────

  /// Clears in-memory state only (does NOT touch Firestore).
  /// Call this before loading another user's favorites (e.g. on logout).
  void clearFavorites() {
    _favoriteIds.clear();
    _favorites.clear();
    _loadedUid = null;
    notifyListeners();
  }
}
