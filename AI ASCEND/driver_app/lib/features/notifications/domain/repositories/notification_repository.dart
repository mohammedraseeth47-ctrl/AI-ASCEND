import '../entities/driver_notification.dart';

abstract class NotificationRepository {
  /// Fetch list of driver notifications
  Future<List<DriverNotification>> getNotifications();

  /// Mark specific notification as read
  Future<void> markAsRead(String id);

  /// Mark all notifications as read
  Future<void> markAllAsRead();

  /// Get unread notification count
  Future<int> getUnreadCount();
}
