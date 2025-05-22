import 'dart:convert';

ModelAddBoardMember modelAddBoardMemberFromJson(Map<String, dynamic> str) =>
    ModelAddBoardMember.fromJson(str);

String modelAddBoardMemberToJson(ModelAddBoardMember data) =>
    json.encode(data.toJson());

class ModelAddBoardMember {
  bool success;
  String message;
  List<Member> members;

  ModelAddBoardMember({
    required this.success,
    required this.message,
    required this.members,
  });

  factory ModelAddBoardMember.fromJson(Map<String, dynamic> json) =>
      ModelAddBoardMember(
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
  int boardId;
  int userId;
  String level;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  Member({
    required this.id,
    required this.boardId,
    required this.userId,
    required this.level,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        boardId: json["board_id"],
        userId: json["user_id"],
        level: json["level"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "board_id": boardId,
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
  int active;
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
