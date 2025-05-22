import 'dart:convert';

ModelAddBoard modelAddBoardFromJson(Map<String, dynamic> str) =>
    ModelAddBoard.fromJson(str);

String modelAddBoardToJson(ModelAddBoard data) => json.encode(data.toJson());

class ModelAddBoard {
  bool success;
  String message;
  Data data;

  ModelAddBoard({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ModelAddBoard.fromJson(Map<String, dynamic> json) => ModelAddBoard(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String name;
  String visibility;
  int userId;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  String encryptedId;

  Data({
    required this.name,
    required this.visibility,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.encryptedId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        visibility: json["visibility"],
        userId: json["user_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        encryptedId: json["encrypted_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "visibility": visibility,
        "user_id": userId,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
        "encrypted_id": encryptedId,
      };
}
