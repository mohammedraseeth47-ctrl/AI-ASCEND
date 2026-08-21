import 'package:trackgo_driver/features/notifications/domain/entities/driver_notification.dart';

class MockNotificationDataSource {
  final List<DriverNotification> _notifications = [
    const DriverNotification(
      id: 'NOTIF-01',
      title: 'New Trip Assignment',
      message:
          'You have been assigned to Route VPM-101 (Villupuram New Bus Stand ⇄ Cuddalore Bus Stand) with Bus TN-32-AB-4521.',
      timeAgo: '15m ago',
      isRead: false,
      type: NotificationType.assignment,
      relatedEntityId: 'TRP-10482',
    ),
    const DriverNotification(
      id: 'NOTIF-02',
      title: 'Route Detour: Panruti Market Section',
      message:
          'Expect slow movement near Panruti Four Roads due to weekly agri market. Maintain scheduled intermediate departure.',
      timeAgo: '1h ago',
      isRead: false,
      type: NotificationType.routeAlert,
      relatedEntityId: 'RTE-VPM-101',
    ),
    const DriverNotification(
      id: 'NOTIF-03',
      title: 'Pre-Trip Inspection Complete',
      message:
          'Bus TN-32-AB-4521 (BUS-402) passed all depot safety and mechanical checks with 92% fuel capacity.',
      timeAgo: '2h ago',
      isRead: true,
      type: NotificationType.maintenance,
      relatedEntityId: 'VEH-4521',
    ),
    const DriverNotification(
      id: 'NOTIF-04',
      title: 'Driver Notice: Monsoon Advisory',
      message:
          'Moderate rain forecast on Cuddalore-Puducherry coastal belt after 11:00 AM. Maintain extended stopping distance.',
      timeAgo: '4h ago',
      isRead: true,
      type: NotificationType.general,
    ),
    const DriverNotification(
      id: 'NOTIF-05',
      title: 'Shift Log Verified & Approved',
      message:
          'Yesterday’s shift log (Villupuram-Tindivanam corridor, 7.5 hrs) was verified and approved by Villupuram Depot Dispatch.',
      timeAgo: 'Yesterday',
      isRead: true,
      type: NotificationType.scheduleUpdate,
    ),
  ];

  Future<List<DriverNotification>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_notifications);
  }

  Future<void> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 200));
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  Future<int> getUnreadCount() async {
    return _notifications.where((n) => !n.isRead).length;
  }
}
