import 'dart:convert';

ModelDuplicateBoard modelDuplicateBoardFromJson(Map<String, dynamic> str) =>
    ModelDuplicateBoard.fromJson(str);

String modelDuplicateBoardToJson(ModelDuplicateBoard data) =>
    json.encode(data.toJson());

class ModelDuplicateBoard {
  bool success;
  String message;
  Board board;

  ModelDuplicateBoard({
    required this.success,
    required this.message,
    required this.board,
  });

  factory ModelDuplicateBoard.fromJson(Map<String, dynamic> json) =>
      ModelDuplicateBoard(
        success: json["success"],
        message: json["message"],
        board: Board.fromJson(json["board"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "board": board.toJson(),
      };
}

class Board {
  String name;
  String visibility;
  int userId;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  String encryptedId;
  List<Card> cards;
  List<Member> members;

  Board({
    required this.name,
    required this.visibility,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.encryptedId,
    required this.cards,
    required this.members,
  });

  factory Board.fromJson(Map<String, dynamic> json) => Board(
        name: json["name"],
        visibility: json["visibility"],
        userId: json["user_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        encryptedId: json["encrypted_id"],
        cards: List<Card>.from(json["cards"].map((x) => Card.fromJson(x))),
        members:
            List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "visibility": visibility,
        "user_id": userId,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
        "encrypted_id": encryptedId,
        "cards": List<dynamic>.from(cards.map((x) => x.toJson())),
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
      };
}

class Card {
  int id;
  int boardId;
  String name;
  int position;
  DateTime createdAt;
  DateTime updatedAt;
  List<Task> tasks;

  Card({
    required this.id,
    required this.boardId,
    required this.name,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
    required this.tasks,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        id: json["id"],
        boardId: json["board_id"],
        name: json["name"],
        position: json["position"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "board_id": boardId,
        "name": name,
        "position": position,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
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
  List<Checklist> checklists;
  List<Member> members;
  List<FileElement> files;
  List<Member> comments;

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
    required this.checklists,
    required this.members,
    required this.files,
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
        checklists: List<Checklist>.from(
            json["checklists"].map((x) => Checklist.fromJson(x))),
        members:
            List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
        files: List<FileElement>.from(
            json["files"].map((x) => FileElement.fromJson(x))),
        comments:
            List<Member>.from(json["comments"].map((x) => Member.fromJson(x))),
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
        "checklists": List<dynamic>.from(checklists.map((x) => x.toJson())),
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
        "files": List<dynamic>.from(files.map((x) => x.toJson())),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
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

class Member {
  int id;
  int? taskId;
  int userId;
  String? comment;
  DateTime createdAt;
  DateTime updatedAt;
  String? level;
  int? boardId;

  Member({
    required this.id,
    this.taskId,
    required this.userId,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.level,
    this.boardId,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        taskId: json["task_id"],
        userId: json["user_id"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        level: json["level"],
        boardId: json["board_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_id": taskId,
        "user_id": userId,
        "comment": comment,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "level": level,
        "board_id": boardId,
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
