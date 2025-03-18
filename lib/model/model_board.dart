import 'dart:convert';

ModelBoard modelBoardFromJson(Map <String, dynamic> str) =>
    ModelBoard.fromJson(str);

String modelBoardToJson(ModelBoard data) => json.encode(data.toJson());

class ModelBoard {
  bool success;
  String message;
  List<Datum> data;

  ModelBoard({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ModelBoard.fromJson(Map<String, dynamic> json) => ModelBoard(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String name;
  String visibility;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;
  String encryptedId;
  User user;
  List<dynamic> members;

  Datum({
    required this.id,
    required this.name,
    required this.visibility,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.encryptedId,
    required this.user,
    required this.members,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        visibility: json["visibility"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        encryptedId: json["encrypted_id"],
        user: User.fromJson(json["user"]),
        members: List<dynamic>.from(json["members"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "visibility": visibility,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "encrypted_id": encryptedId,
        "user": user.toJson(),
        "members": List<dynamic>.from(members.map((x) => x)),
      };
}

class User {
  int id;
  String name;
  String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
      };
}
