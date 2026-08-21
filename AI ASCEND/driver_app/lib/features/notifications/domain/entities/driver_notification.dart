import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  assignment,
  scheduleUpdate,
  routeAlert,
  maintenance,
  general,
  weather,
  inspection,
  shiftVerification,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.assignment:
        return 'Shift Assignment';
      case NotificationType.scheduleUpdate:
        return 'Schedule Update';
      case NotificationType.routeAlert:
        return 'Route Advisory';
      case NotificationType.maintenance:
      case NotificationType.inspection:
        return 'Vehicle Inspection';
      case NotificationType.weather:
        return 'Weather Advisory';
      case NotificationType.shiftVerification:
        return 'Shift Verification';
      case NotificationType.general:
        return 'Operations Notice';
    }
  }

  String get firestoreValue {
    switch (this) {
      case NotificationType.assignment:
        return 'assignment';
      case NotificationType.scheduleUpdate:
        return 'schedule_update';
      case NotificationType.routeAlert:
        return 'route_alert';
      case NotificationType.maintenance:
      case NotificationType.inspection:
        return 'vehicle_inspection';
      case NotificationType.weather:
        return 'weather_advisory';
      case NotificationType.shiftVerification:
        return 'shift_verification';
      case NotificationType.general:
        return 'general';
    }
  }

  static NotificationType fromFirestore(String? value) {
    switch (value) {
      case 'assignment':
      case 'new_trip_assignment':
        return NotificationType.assignment;
      case 'schedule_update':
        return NotificationType.scheduleUpdate;
      case 'route_alert':
      case 'route_advisory':
        return NotificationType.routeAlert;
      case 'maintenance':
      case 'vehicle_inspection':
        return NotificationType.inspection;
      case 'weather':
      case 'weather_advisory':
        return NotificationType.weather;
      case 'shift_verification':
        return NotificationType.shiftVerification;
      default:
        return NotificationType.general;
    }
  }
}

class DriverNotification {
  final String id;
  final String notificationId;
  final String driverId;
  final String title;
  final String message;
  final String timeAgo;
  final bool isRead;
  final NotificationType type;
  final String? relatedEntityId;
  final DateTime? createdAt;

  const DriverNotification({
    required this.id,
    this.notificationId = '',
    this.driverId = '',
    required this.title,
    required this.message,
    required this.timeAgo,
    this.isRead = false,
    required this.type,
    this.relatedEntityId,
    this.createdAt,
  });

  factory DriverNotification.fromFirestore(
    Map<String, dynamic> data,
    String docId,
  ) {
    final createdDt = _parseTimestamp(data['createdAt'] ?? data['timestamp']);
    final timeStr = data['timeAgo']?.toString() ?? _formatTimeAgo(createdDt);
    final readVal =
        (data['read'] as bool?) ?? (data['isRead'] as bool?) ?? false;

    return DriverNotification(
      id: docId,
      notificationId: data['notificationId']?.toString() ?? docId,
      driverId: data['driverId']?.toString() ?? '',
      title: data['title']?.toString() ?? 'Operations Notice',
      message: data['message']?.toString() ?? '',
      timeAgo: timeStr,
      isRead: readVal,
      type: NotificationTypeExtension.fromFirestore(data['type']?.toString()),
      relatedEntityId: data['relatedEntityId']?.toString(),
      createdAt: createdDt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'notificationId': notificationId.isNotEmpty ? notificationId : id,
      'driverId': driverId,
      'title': title,
      'message': message,
      'type': type.firestoreValue,
      'read': isRead,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      if (relatedEntityId != null) 'relatedEntityId': relatedEntityId,
    };
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static String _formatTimeAgo(DateTime? dt) {
    if (dt == null) return 'Recent';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  DriverNotification copyWith({
    String? id,
    String? notificationId,
    String? driverId,
    String? title,
    String? message,
    String? timeAgo,
    bool? isRead,
    NotificationType? type,
    String? relatedEntityId,
    DateTime? createdAt,
  }) {
    return DriverNotification(
      id: id ?? this.id,
      notificationId: notificationId ?? this.notificationId,
      driverId: driverId ?? this.driverId,
      title: title ?? this.title,
      message: message ?? this.message,
      timeAgo: timeAgo ?? this.timeAgo,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
