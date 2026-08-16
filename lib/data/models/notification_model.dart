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
}
