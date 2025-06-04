import 'dart:convert';

ModelMoveTask modelMoveTaskFromJson(Map <String, dynamic> str) =>
    ModelMoveTask.fromJson(str);

String modelMoveTaskToJson(ModelMoveTask data) => json.encode(data.toJson());

class ModelMoveTask {
  bool success;
  String message;
  Task task;

  ModelMoveTask({
    required this.success,
    required this.message,
    required this.task,
  });

  factory ModelMoveTask.fromJson(Map<String, dynamic> json) => ModelMoveTask(
        success: json["success"],
        message: json["message"],
        task: Task.fromJson(json["task"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
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
  Card card;
  List<Checklist> checklists;
  List<FileElement> files;
  List<Member> members;
  List<Comment> comments;

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
    required this.card,
    required this.checklists,
    required this.files,
    required this.members,
    required this.comments,
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
        card: Card.fromJson(json["card"]),
        checklists: List<Checklist>.from(
            json["checklists"].map((x) => Checklist.fromJson(x))),
        files: List<FileElement>.from(
            json["files"].map((x) => FileElement.fromJson(x))),
        members:
            List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
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
        "card": card.toJson(),
        "checklists": List<dynamic>.from(checklists.map((x) => x.toJson())),
        "files": List<dynamic>.from(files.map((x) => x.toJson())),
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
      };
}

class Card {
  int id;
  int boardId;
  String name;
  int position;
  DateTime createdAt;
  DateTime updatedAt;

  Card({
    required this.id,
    required this.boardId,
    required this.name,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        id: json["id"],
        boardId: json["board_id"],
        name: json["name"],
        position: json["position"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "board_id": boardId,
        "name": name,
        "position": position,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Checklist {
  int id;
  int taskId;
  String name;
  bool isChecked;
  DateTime createdAt;
  DateTime updatedAt;

  Checklist({
    required this.id,
    required this.taskId,
    required this.name,
    required this.isChecked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) => Checklist(
        id: json["id"],
        taskId: json["task_id"],
        name: json["name"],
        isChecked: json["is_checked"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_id": taskId,
        "name": name,
        "is_checked": isChecked,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Comment {
  int id;
  int taskId;
  int userId;
  String comment;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  Comment({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        taskId: json["task_id"],
        userId: json["user_id"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_id": taskId,
        "user_id": userId,
        "comment": comment,
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
  String? nim;
  String? nidn;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.active,
    required this.role,
    this.nim,
    this.nidn,
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
        nim: json["nim"] ?? "",
        nidn: json["nidn"] ?? "",
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
        "nim": nim ?? "",
        "nidn": nidn ?? "",
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class FileElement {
  int id;
  int taskId;
  int userId;
  String displayName;
  String encryptedFilename;
  String originalFilename;
  String filePath;
  String mimeType;
  int fileSize;
  DateTime createdAt;
  DateTime updatedAt;

  FileElement({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.displayName,
    required this.encryptedFilename,
    required this.originalFilename,
    required this.filePath,
    required this.mimeType,
    required this.fileSize,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        id: json["id"],
        taskId: json["task_id"],
        userId: json["user_id"],
        displayName: json["display_name"],
        encryptedFilename: json["encrypted_filename"],
        originalFilename: json["original_filename"],
        filePath: json["file_path"],
        mimeType: json["mime_type"],
        fileSize: json["file_size"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_id": taskId,
        "user_id": userId,
        "display_name": displayName,
        "encrypted_filename": encryptedFilename,
        "original_filename": originalFilename,
        "file_path": filePath,
        "mime_type": mimeType,
        "file_size": fileSize,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
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
