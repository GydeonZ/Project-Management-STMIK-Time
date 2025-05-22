import 'dart:convert';

ModelBoard modelBoardFromJson(Map<String, dynamic> str) =>
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
    String encryptedId;
    User user;
    List<Member> members;

    Datum({
        required this.id,
        required this.name,
        required this.visibility,
        required this.userId,
        required this.encryptedId,
        required this.user,
        required this.members,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        visibility: json["visibility"],
        userId: json["user_id"],
        encryptedId: json["encrypted_id"],
        user: User.fromJson(json["user"]),
        members: List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "visibility": visibility,
        "user_id": userId,
        "encrypted_id": encryptedId,
        "user": user.toJson(),
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
    };
}

class Member {
    int id;
    int boardId;
    int userId;
    String level;
    User user;

    Member({
        required this.id,
        required this.boardId,
        required this.userId,
        required this.level,
        required this.user,
    });

    factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        boardId: json["board_id"],
        userId: json["user_id"],
        level: json["level"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "board_id": boardId,
        "user_id": userId,
        "level": level,
        "user": user.toJson(),
    };
}

class User {
    int id;
    String name;

    User({
        required this.id,
        required this.name,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
