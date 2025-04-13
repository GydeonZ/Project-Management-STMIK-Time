import 'dart:convert';

ModelFetchTaskId modelFetchTaskIdFromJson(Map<String, dynamic> str) =>
    ModelFetchTaskId.fromJson(str);

String modelFetchTaskIdToJson(ModelFetchTaskId data) =>
    json.encode(data.toJson());

class ModelFetchTaskId {
  bool success;
  Task task;

  ModelFetchTaskId({
    required this.success,
    required this.task,
  });

  factory ModelFetchTaskId.fromJson(Map<String, dynamic> json) =>
      ModelFetchTaskId(
        success: json["success"],
        task: Task.fromJson(json["task"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "task": task.toJson(),
      };
}

class Task {
  int id;
  int cardId;
  String name;
  String description;
  int position;
  DateTime startTime;
  DateTime endTime;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic>? membersInvite; // Made nullable with ?
  Card card;
  List<dynamic>? checklists; // Made nullable with ?
  List<dynamic>? files; // Made nullable with ?
  List<Activity> activities;
  List<dynamic>? comments; // Made nullable with ?
  List<dynamic>? members; // Made nullable with ?

  Task({
    required this.id,
    required this.cardId,
    required this.name,
    required this.description,
    required this.position,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
    this.membersInvite, // Remove 'required'
    required this.card,
    this.checklists, // Remove 'required'
    this.files, // Remove 'required'
    required this.activities,
    this.comments, // Remove 'required'
    this.members, // Remove 'required'
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        cardId: json["card_id"],
        name: json["name"],
        description: json["description"],
        position: json["position"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        membersInvite: json["members_invite"] != null
            ? List<dynamic>.from(json["members_invite"].map((x) => x))
            : null,
        card: Card.fromJson(json["card"]),
        checklists: json["checklists"] != null
            ? List<dynamic>.from(json["checklists"].map((x) => x))
            : null,
        files: json["files"] != null
            ? List<dynamic>.from(json["files"].map((x) => x))
            : null,
        activities: List<Activity>.from(
            json["activities"].map((x) => Activity.fromJson(x))),
        comments: json["comments"] != null
            ? List<dynamic>.from(json["comments"].map((x) => x))
            : null,
        members: json["members"] != null
            ? List<dynamic>.from(json["members"].map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "card_id": cardId,
        "name": name,
        "description": description,
        "position": position,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "members_invite": membersInvite != null
            ? List<dynamic>.from(membersInvite!.map((x) => x))
            : [],
        "card": card.toJson(),
        "checklists": checklists != null
            ? List<dynamic>.from(checklists!.map((x) => x))
            : [],
        "files": files != null ? List<dynamic>.from(files!.map((x) => x)) : [],
        "activities": List<dynamic>.from(activities.map((x) => x.toJson())),
        "comments":
            comments != null ? List<dynamic>.from(comments!.map((x) => x)) : [],
        "members":
            members != null ? List<dynamic>.from(members!.map((x) => x)) : [],
      };
}

class Activity {
  int id;
  int taskId;
  int userId;
  String activity;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  Activity({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.activity,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json["id"],
        taskId: json["task_id"],
        userId: json["user_id"],
        activity: json["activity"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_id": taskId,
        "user_id": userId,
        "activity": activity,
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

class Card {
  int id;
  int boardId;
  String name;
  int position;
  DateTime createdAt;
  DateTime updatedAt;
  Board board;

  Card({
    required this.id,
    required this.boardId,
    required this.name,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
    required this.board,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        id: json["id"],
        boardId: json["board_id"],
        name: json["name"],
        position: json["position"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        board: Board.fromJson(json["board"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "board_id": boardId,
        "name": name,
        "position": position,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "board": board.toJson(),
      };
}

class Board {
  int id;
  String name;
  String visibility;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;
  String encryptedId;

  Board({
    required this.id,
    required this.name,
    required this.visibility,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.encryptedId,
  });

  factory Board.fromJson(Map<String, dynamic> json) => Board(
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
