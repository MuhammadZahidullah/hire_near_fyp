import 'package:flutter/material.dart';

class AppSnackBar {
  // private base method
  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
    Duration duration,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(message, style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating, // ← required for margin
        margin: EdgeInsets.all(16),
        duration: duration,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // success
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    _show(
      context,
      message,
      Colors.green,
      Icons.check_circle,
      duration ?? Duration(seconds: 3),
    );
  }

  // error
  static void showError(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    _show(
      context,
      message,
      Colors.red,
      Icons.error_outline,
      duration ?? Duration(seconds: 3),
    );
  }

  // warning
  static void showWarning(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    _show(
      context,
      message,
      Colors.orange,
      Icons.warning_amber,
      duration ?? Duration(seconds: 2),
    );
  }
}
