enum NotificationType { success, surpassed }

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String vehicleId;
  final NotificationType type;
  final String timeAgo;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.vehicleId,
    required this.type,
    required this.timeAgo,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    NotificationType type = NotificationType.success;
    if (json['notification_type'] == 'outbid') {
      type = NotificationType.surpassed;
    }
    
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Notification',
      message: json['message'] ?? '',
      vehicleId: json['sell_post']?.toString() ?? '',
      type: type,
      timeAgo: 'Just now', // Could be formatted from json['created_at']
    );
  }
}
