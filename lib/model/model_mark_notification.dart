import 'dart:convert';

ModelMarkNotification modelMarkNotificationFromJson(Map<String, dynamic> str) =>
    ModelMarkNotification.fromJson(str);

String modelMarkNotificationToJson(ModelMarkNotification data) =>
    json.encode(data.toJson());

class ModelMarkNotification {
  bool success;
  Notification notification;

  ModelMarkNotification({
    required this.success,
    required this.notification,
  });

  factory ModelMarkNotification.fromJson(Map<String, dynamic> json) =>
      ModelMarkNotification(
        success: json["success"],
        notification: Notification.fromJson(json["notification"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "notification": notification.toJson(),
      };
}

class Notification {
  int id;
  int taskId;
  int senderId;
  int receiverId;
  String message;
  bool isRead;
  DateTime createdAt;
  DateTime updatedAt;

  Notification({
    required this.id,
    required this.taskId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json["id"],
        taskId: json["task_id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        message: json["message"],
        isRead: json["is_read"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_id": taskId,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message": message,
        "is_read": isRead,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
