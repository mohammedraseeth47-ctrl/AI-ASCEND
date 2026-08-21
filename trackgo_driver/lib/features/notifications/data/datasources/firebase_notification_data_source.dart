import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:trackgo_driver/features/notifications/domain/entities/driver_notification.dart';

class FirebaseNotificationDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseNotificationDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance;

  String? get _currentUid => _auth.currentUser?.uid;

  static List<DriverNotification> getDemoNotifications(String uid) {
    return [
      DriverNotification(
        id: 'NOTIF-001',
        notificationId: 'NOTIF-001',
        driverId: uid,
        title: 'Shift Assignment Confirmed',
        message:
            'Assigned to Route VPM-CUD-01 (Villupuram → Cuddalore) with Bus TN 32 AB 1234 (BUS001) for today.',
        timeAgo: '10m ago',
        isRead: false,
        type: NotificationType.assignment,
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      DriverNotification(
        id: 'NOTIF-002',
        notificationId: 'NOTIF-002',
        driverId: uid,
        title: 'NH-45 Road Diversion Advisory',
        message:
            'Slow traffic near Panruti Overbridge due to road maintenance. Please maintain safe headway.',
        timeAgo: '45m ago',
        isRead: false,
        type: NotificationType.routeAlert,
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      DriverNotification(
        id: 'NOTIF-003',
        notificationId: 'NOTIF-003',
        driverId: uid,
        title: 'Pre-Trip Inspection Passed',
        message:
            'Vehicle BUS001 pre-trip diagnostics verified at Villupuram Central Depot. Fuel at 92%.',
        timeAgo: '2h ago',
        isRead: true,
        type: NotificationType.inspection,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  Future<List<DriverNotification>> getNotifications() async {
    final uid = _currentUid ?? 'DRV001';

    try {
      final querySnapshot = await _firestore
          .collection('notifications')
          .where('driverId', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final list = querySnapshot.docs
            .map((doc) => DriverNotification.fromFirestore(doc.data(), doc.id))
            .toList();

        list.sort((a, b) {
          final aTime = a.createdAt ?? DateTime(2020);
          final bTime = b.createdAt ?? DateTime(2020);
          return bTime.compareTo(aTime);
        });

        return list;
      }
    } catch (e) {
      debugPrint(
        'Firestore notifications read error ($e) - using demo fallback',
      );
    }

    return getDemoNotifications(uid);
  }

  Future<void> markAsRead(String id) async {
    try {
      await _firestore.collection('notifications').doc(id).update({
        'read': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    final uid = _currentUid;
    if (uid == null) return;

    try {
      final querySnapshot = await _firestore
          .collection('notifications')
          .where('driverId', isEqualTo: uid)
          .where('read', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {
          'read': true,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    } catch (_) {}
  }

  Future<int> getUnreadCount() async {
    final notifications = await getNotifications();
    return notifications.where((n) => !n.isRead).length;
  }
}
