import 'dart:convert';

ModelAddAnggota modelAddAnggotaFromJson(Map <String, dynamic> str) =>
    ModelAddAnggota.fromJson(str);

String modelAddAnggotaToJson(ModelAddAnggota data) =>
    json.encode(data.toJson());

class ModelAddAnggota {
  bool success;
  String message;
  List<Member> members;

  ModelAddAnggota({
    required this.success,
    required this.message,
    required this.members,
  });

  factory ModelAddAnggota.fromJson(Map<String, dynamic> json) =>
      ModelAddAnggota(
        success: json["success"],
        message: json["message"],
        members:
            List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
      };
}

class Member {
  int id;
  int taskId;
  int userId;
  String level;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  Member({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.level,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        taskId: json["task_id"],
        userId: json["user_id"],
        level: json["level"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_id": taskId,
        "user_id": userId,
        "level": level,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user.toJson(),
      };
}

class User {
  int id;
  String name;
  String email;
  DateTime emailVerifiedAt;
  String role;
  String nim;
  dynamic nidn;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
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
        "role": role,
        "nim": nim,
        "nidn": nidn,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
