import 'dart:convert';

ModelKomentar modelKomentarFromJson(Map<String, dynamic> str) =>
    ModelKomentar.fromJson(str);

String modelKomentarToJson(ModelKomentar data) => json.encode(data.toJson());

class ModelKomentar {
  bool success;
  String message;
  Comment comment;

  ModelKomentar({
    required this.success,
    required this.message,
    required this.comment,
  });

  factory ModelKomentar.fromJson(Map<String, dynamic> json) => ModelKomentar(
        success: json["success"],
        message: json["message"],
        comment: Comment.fromJson(json["comment"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "comment": comment.toJson(),
      };
}

class Comment {
  int userId;
  String comment;
  int taskId;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  User user;

  Comment({
    required this.userId,
    required this.comment,
    required this.taskId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        userId: json["user_id"],
        comment: json["comment"],
        taskId: json["task_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "comment": comment,
        "task_id": taskId,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
        "user": user.toJson(),
      };
}

class User {
  int id;
  String name;
  String email;
  DateTime emailVerifiedAt;
  int active;
  String role;
  dynamic nim;
  String nidn;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.active,
    required this.role,
    required this.nim,
    required this.nidn,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
        active: json["active"],
        role: json["role"],
        nim: json["nim"],
        nidn: json["nidn"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt.toIso8601String(),
        "active": active,
        "role": role,
        "nim": nim,
        "nidn": nidn,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
