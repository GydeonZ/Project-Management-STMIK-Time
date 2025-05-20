import 'dart:convert';

ModelFetchNotifikasi modelFetchNotifikasiFromJson(Map<String,dynamic> str) =>
    ModelFetchNotifikasi.fromJson(str);

String modelFetchNotifikasiToJson(ModelFetchNotifikasi data) =>
    json.encode(data.toJson());

class ModelFetchNotifikasi {
  bool success;
  List<Datum> data;

  ModelFetchNotifikasi({
    required this.success,
    required this.data,
  });

  factory ModelFetchNotifikasi.fromJson(Map<String, dynamic> json) =>
      ModelFetchNotifikasi(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  int taskId;
  int? senderId;
  int receiverId;
  String message;
  bool isRead;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.taskId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
