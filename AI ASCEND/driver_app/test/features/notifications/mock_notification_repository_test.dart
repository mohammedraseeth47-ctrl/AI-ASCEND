import 'package:flutter_test/flutter_test.dart';
import 'package:trackgo_driver/features/notifications/data/datasources/mock_notification_data_source.dart';
import 'package:trackgo_driver/features/notifications/data/repositories/mock_notification_repository.dart';

void main() {
  group('MockNotificationRepository Tests', () {
    late MockNotificationRepository repository;

    setUp(() {
      repository = MockNotificationRepository(dataSource: MockNotificationDataSource());
    });

    test('getNotifications returns list of initial notifications', () async {
      final notifications = await repository.getNotifications();
      expect(notifications.isNotEmpty, isTrue);
      expect(notifications.any((n) => !n.isRead), isTrue);
    });

    test('markAsRead updates isRead state for target item', () async {
      final initialList = await repository.getNotifications();
      final targetId = initialList.firstWhere((n) => !n.isRead).id;

      await repository.markAsRead(targetId);

      final updatedList = await repository.getNotifications();
      final updatedItem = updatedList.firstWhere((n) => n.id == targetId);
      expect(updatedItem.isRead, isTrue);
    });

    test('markAllAsRead marks every notification as read', () async {
      await repository.markAllAsRead();
      final unreadCount = await repository.getUnreadCount();
      expect(unreadCount, equals(0));
    });
  });
}
