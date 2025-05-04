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
  List<MembersInvite> membersInvite;
  Card card;
  List<Checklist> checklists;
  List<FileElement> files;
  List<Activity> activities;
  List<Comment> comments;
  List<Member> members;

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
    required this.membersInvite,
    required this.card,
    required this.checklists,
    required this.files,
    required this.activities,
    required this.comments,
    required this.members,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    try {
      return Task(
        id: json["id"],
        cardId: json["card_id"],
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        position: json["position"] ?? 0,
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        membersInvite: json["members_invite"] != null
            ? List<MembersInvite>.from(
                json["members_invite"].map((x) => MembersInvite.fromJson(x)))
            : [],
        card: json["card"] != null
            ? Card.fromJson(json["card"])
            : Card(
                id: 0,
                boardId: 0,
                name: "",
                position: 0,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                board: Board(
                  id: 0,
                  name: "",
                  visibility: "",
                  userId: 0,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  encryptedId: "",
                ),
              ),
        checklists: _parseListSafely<Checklist>(
            json["checklists"], (x) => Checklist.fromJson(x)),
        files: _parseListSafely<FileElement>(
            json["files"], (x) => FileElement.fromJson(x)),
        activities: _parseListSafely<Activity>(
            json["activities"], (x) => Activity.fromJson(x)),
        comments: _parseListSafely<Comment>(
            json["comments"], (x) => Comment.fromJson(x)),
        members: _parseListSafely<Member>(
            json["members"], (x) => Member.fromJson(x)),
      );
    } catch (e) {
      print("Error parsing task: $e");
      // Return a default task object in case of error
      return Task(
        id: json["id"] ?? 0,
        cardId: json["card_id"] ?? 0,
        name: json["name"] ?? "Error parsing task",
        description: json["description"] ?? "",
        position: json["position"] ?? 0,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(days: 1)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        membersInvite: [],
        card: Card(
          id: 0,
          boardId: 0,
          name: "",
          position: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          board: Board(
            id: 0,
            name: "",
            visibility: "",
            userId: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            encryptedId: "",
          ),
        ),
        checklists: [],
        files: [],
        activities: [],
        comments: [],
        members: [],
      );
    }
  }

  // Add this helper method to safely parse lists with error handling
  static List<T> _parseListSafely<T>(
      dynamic jsonList, T Function(Map<String, dynamic>) fromJson) {
    if (jsonList == null) return [];

    try {
      return List<T>.from(jsonList.map((x) {
        try {
          return fromJson(x);
        } catch (e) {
          print("Error parsing item in list: $e");
          return null;
        }
      }).where((x) => x != null));
    } catch (e) {
      print("Error parsing list: $e");
      return [];
    }
  }

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
        "members_invite":
            List<dynamic>.from(membersInvite.map((x) => x.toJson())),
        "card": card.toJson(),
        "checklists": List<dynamic>.from(checklists.map((x) => x.toJson())),
        "files": List<dynamic>.from(files.map((x) => x.toJson())),
        "activities": List<dynamic>.from(activities.map((x) => x.toJson())),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
      };
}

class Activity {
  int id;
  int taskId;
  int userId;
  String activity;
  DateTime createdAt;
  DateTime updatedAt;
  MembersInvite user;

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
        user: MembersInvite.fromJson(json["user"]),
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

class MembersInvite {
  int id;
  String name; // Changed from enum to String
  String email; // Changed from enum to String
  DateTime emailVerifiedAt;
  String role; // Changed from enum to String
  String? nim;
  String? nidn;
  DateTime createdAt;
  DateTime updatedAt;
  Pivot? pivot;

  MembersInvite({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.role,
    required this.nim,
    required this.nidn,
    required this.createdAt,
    required this.updatedAt,
    this.pivot,
  });

  factory MembersInvite.fromJson(Map<String, dynamic> json) => MembersInvite(
        id: json["id"],
        name: json["name"] ?? "Unknown User", // Direct assignment
        email: json["email"] ?? "unknown@example.com", // Direct assignment
        emailVerifiedAt: json["email_verified_at"] != null
            ? DateTime.parse(json["email_verified_at"])
            : DateTime.now(),
        role: json["role"] ?? "Member", // Direct assignment
        nim: json["nim"],
        nidn: json["nidn"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name, // Direct use
        "email": email, // Direct use
        "email_verified_at": emailVerifiedAt.toIso8601String(),
        "role": role, // Direct use
        "nim": nim,
        "nidn": nidn,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "pivot": pivot?.toJson(),
      };
}

class Pivot {
  int taskId;
  int userId;
  String level;
  DateTime createdAt;
  DateTime updatedAt;

  Pivot({
    required this.taskId,
    required this.userId,
    required this.level,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        taskId: json["task_id"],
        userId: json["user_id"],
        level: json["level"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "task_id": taskId,
        "user_id": userId,
        "level": level,
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
  MembersInvite user;

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
        user: MembersInvite.fromJson(json["user"]),
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

  String get fullFilePath {
    // Jika file_path sudah memiliki URL lengkap, gunakan langsung
    if (filePath.startsWith('http')) {
      return filePath;
    }

    // Jika tidak, gabungkan dengan base URL
    return "https://bursting-ferret-yearly.ngrok-free.app/storage/$filePath";
  }

  String get fileExtension {
    return displayName.split('.').last.toLowerCase();
  }

  bool get isImage {
    final ext = fileExtension;
    return ext == 'jpg' || ext == 'jpeg' || ext == 'png' || ext == 'gif';
  }

  bool get isPdf {
    return fileExtension == 'pdf';
  }

  String get formattedFileSize {
    if (fileSize < 1024) {
      return "$fileSize B";
    } else if (fileSize < 1024 * 1024) {
      return "${(fileSize / 1024).toStringAsFixed(2)} KB";
    } else {
      return "${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB";
    }
  }
}

class Member {
  int id;
  int taskId;
  int userId;
  String level;
  DateTime createdAt;
  DateTime updatedAt;
  MembersInvite user;

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
        user: MembersInvite.fromJson(json["user"]),
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
