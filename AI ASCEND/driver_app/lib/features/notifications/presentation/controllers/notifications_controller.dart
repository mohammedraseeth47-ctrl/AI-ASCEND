import 'package:flutter/foundation.dart';
import 'package:trackgo_driver/features/notifications/domain/entities/driver_notification.dart';
import 'package:trackgo_driver/features/notifications/domain/repositories/notification_repository.dart';

class NotificationsController extends ChangeNotifier {
  final NotificationRepository _repository;

  List<DriverNotification> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _filterUnreadOnly = false;

  NotificationsController(this._repository);

  List<DriverNotification> get notifications {
    if (_filterUnreadOnly) {
      return _notifications.where((n) => !n.isRead).toList();
    }
    return _notifications;
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get filterUnreadOnly => _filterUnreadOnly;

  Future<void> loadNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _repository.getNotifications();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> markAsRead(String id) async {
    await _repository.markAsRead(id);
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead();
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  void toggleUnreadFilter(bool unreadOnly) {
    _filterUnreadOnly = unreadOnly;
    notifyListeners();
  }
}
