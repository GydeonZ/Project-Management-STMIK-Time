import 'dart:convert';

ModelUpdateBoard modelUpdateBoardFromJson(Map<String, dynamic> str) => ModelUpdateBoard.fromJson(str);

String modelUpdateBoardToJson(ModelUpdateBoard data) => json.encode(data.toJson());

class ModelUpdateBoard {
    bool success;
    String message;
    Data data;

    ModelUpdateBoard({
        required this.success,
        required this.message,
        required this.data,
    });

    factory ModelUpdateBoard.fromJson(Map<String, dynamic> json) => ModelUpdateBoard(
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
    int id;
    String name;
    String visibility;
    int userId;
    DateTime createdAt;
    DateTime updatedAt;
    String encryptedId;

    Data({
        required this.id,
        required this.name,
        required this.visibility,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
        required this.encryptedId,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        visibility: json["visibility"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        encryptedId: json["encrypted_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "visibility": visibility,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "encrypted_id": encryptedId,
    };
}
