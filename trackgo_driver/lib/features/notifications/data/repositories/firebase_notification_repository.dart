import 'package:trackgo_driver/features/notifications/data/datasources/firebase_notification_data_source.dart';
import 'package:trackgo_driver/features/notifications/domain/entities/driver_notification.dart';
import 'package:trackgo_driver/features/notifications/domain/repositories/notification_repository.dart';

class FirebaseNotificationRepository implements NotificationRepository {
  final FirebaseNotificationDataSource _dataSource;

  FirebaseNotificationRepository({FirebaseNotificationDataSource? dataSource})
    : _dataSource = dataSource ?? FirebaseNotificationDataSource();

  @override
  Future<List<DriverNotification>> getNotifications() {
    return _dataSource.getNotifications();
  }

  @override
  Future<void> markAsRead(String id) {
    return _dataSource.markAsRead(id);
  }

  @override
  Future<void> markAllAsRead() {
    return _dataSource.markAllAsRead();
  }

  @override
  Future<int> getUnreadCount() {
    return _dataSource.getUnreadCount();
  }
}
