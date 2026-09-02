import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/notifications/models/notifications_model.dart';
import 'package:hire_near_fyp/feature/notifications/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'booking_request':
        return Icons.person_add_alt_1_outlined;
      case 'booking_accepted':
      case 'booking':
        return Icons.check_circle_outline;
      case 'booking_rejected':
      case 'cancel':
        return Icons.cancel_outlined;
      case 'job_completed':
      case 'completed':
        return Icons.verified_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'booking_request':
        return const Color(0xFF6C3CE1);
      case 'booking_accepted':
      case 'booking':
        return const Color(0xFF2563EB);
      case 'booking_rejected':
      case 'cancel':
        return const Color(0xFFDC2626);
      case 'job_completed':
      case 'completed':
        return const Color(0xFF16A34A);
      default:
        return const Color(0xFF6C3CE1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final notifications = provider.notifications;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (provider.hasUnread)
            TextButton(
              onPressed: () {
                context.read<NotificationProvider>().markAllAsRead();
              },
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  color: Color(0xFF6C3CE1),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
      body: provider.isLoading && notifications.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6C3CE1),
              ),
            )
          : RefreshIndicator(
              color: const Color(0xFF6C3CE1),
              onRefresh: () =>
                  context.read<NotificationProvider>().loadNotifications(),
              child: notifications.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6C3CE1)
                                        .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.notifications_none,
                                    size: 48,
                                    color: Color(0xFF6C3CE1),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No Notifications Yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'You will see updates about your bookings here',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: notifications.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        final typeColor = _getColorForType(notification.type);

                        return _NotificationCard(
                          notification: notification,
                          typeColor: typeColor,
                          typeIcon: _getIconForType(notification.type),
                          formattedTime: _formatTime(notification.createdAt),
                          onTap: () {
                            if (!notification.isRead) {
                              context
                                  .read<NotificationProvider>()
                                  .markAsRead(notification.id);
                            }
                          },
                        );
                      },
                    ),
            ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final Color typeColor;
  final IconData typeIcon;
  final String formattedTime;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.typeColor,
    required this.typeIcon,
    required this.formattedTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white
              : const Color(0xFF6C3CE1).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: notification.isRead
                ? Colors.grey.shade200
                : const Color(0xFF6C3CE1).withValues(alpha: 0.25),
            width: notification.isRead ? 1 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                typeIcon,
                color: typeColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title.isNotEmpty
                              ? notification.title
                              : 'Notification',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: notification.isRead
                                ? FontWeight.w600
                                : FontWeight.bold,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF6C3CE1),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message.isNotEmpty
                        ? notification.message
                        : 'No details available',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
