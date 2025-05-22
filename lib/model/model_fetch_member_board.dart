import 'dart:convert';

ModelFetchBoardMember modelFetchBoardMemberFromJson(Map<String, dynamic> str) =>
    ModelFetchBoardMember.fromJson(str);

String modelFetchBoardMemberToJson(ModelFetchBoardMember data) =>
    json.encode(data.toJson());

class ModelFetchBoardMember {
  bool success;
  String message;
  BoardOwner boardOwner;
  List<Member> members;

  ModelFetchBoardMember({
    required this.success,
    required this.message,
    required this.boardOwner,
    required this.members,
  });

  factory ModelFetchBoardMember.fromJson(Map<String, dynamic> json) =>
      ModelFetchBoardMember(
        success: json["success"],
        message: json["message"],
        boardOwner: BoardOwner.fromJson(json["board_owner"]),
        members:
            List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "board_owner": boardOwner.toJson(),
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
      };
}

class BoardOwner {
  int id;
  String name;
  String email;
  DateTime emailVerifiedAt;
  int active;
  String role;
  String? nim;
  String? nidn;
  DateTime createdAt;
  DateTime updatedAt;

  BoardOwner({
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

  factory BoardOwner.fromJson(Map<String, dynamic> json) => BoardOwner(
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

class Member {
  int id;
  int boardId;
  int userId;
  String level;
  DateTime createdAt;
  DateTime updatedAt;
  BoardOwner user;

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
        user: BoardOwner.fromJson(json["user"]),
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
