import 'package:cctv_app/core/network/models/app_notification_meta.dart';

class AppNotificationItem {
  final int notificationId;
  final int? userId;
  final String? notificationType;
  final String? notificationStatus;
  final String title;
  final String message;
  final String? notificationMeta;
  final AppNotificationMeta? parsedMeta;
  final String? createdAt;

  const AppNotificationItem({
    required this.notificationId,
    this.userId,
    this.notificationType,
    this.notificationStatus,
    required this.title,
    required this.message,
    this.notificationMeta,
    this.parsedMeta,
    this.createdAt,
  });

  factory AppNotificationItem.fromJson(Map<String, dynamic> json) {
    final notificationId = json['notification_id'];
    final userId = json['user_id'];
    final detail = (json['notification_detail'] as String?)?.trim();
    final type = (json['notification_type'] as String?)?.trim();
    final status = (json['notification_status'] as String?)?.trim();

    return AppNotificationItem(
      notificationId: notificationId is int
          ? notificationId
          : int.parse('$notificationId'),
      userId: userId == null ? null : int.tryParse('$userId'),
      notificationType: type,
      notificationStatus: status,
      title: _titleFromType(type),
      message: detail == null || detail.isEmpty
          ? 'No details available'
          : detail,
      notificationMeta: json['notification_meta'] as String?,
      parsedMeta: AppNotificationMeta.tryParse(json['notification_meta']),
      createdAt: json['created_at'] as String?,
    );
  }

  bool get isReminder {
    final combined = [
      notificationType,
      title,
      message,
    ].whereType<String>().join(' ').toLowerCase();

    return combined.contains('remind') || combined.contains('reminder');
  }

  static String _titleFromType(String? type) {
    return switch (type) {
      'U' => 'Update',
      'A' => 'Alert',
      'P' => 'Post',
      _ => 'Notification',
    };
  }
}
