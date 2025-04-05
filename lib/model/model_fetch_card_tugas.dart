import 'dart:convert';

ModelFetchCardTugas modelFetchCardTugasFromJson(Map<String, dynamic> str) =>
    ModelFetchCardTugas.fromJson(str);

String modelFetchCardTugasToJson(ModelFetchCardTugas data) =>
    json.encode(data.toJson());

class ModelFetchCardTugas {
  bool success;
  List<Board> boards;

  ModelFetchCardTugas({
    required this.success,
    required this.boards,
  });

  factory ModelFetchCardTugas.fromJson(Map<String, dynamic> json) =>
      ModelFetchCardTugas(
        success: json["success"] ?? false,
        boards: List<Board>.from(
          (json["boards"] ?? []).map((x) => Board.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "boards": List<dynamic>.from(boards.map((x) => x.toJson())),
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
  List<Card> cards;

  Board({
    required this.id,
    required this.name,
    required this.visibility,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.encryptedId,
    required this.cards,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    try {
      return Board(
        id: json['id'],
        name: json['name'] ?? '',
        visibility: json['visibility'] ?? 'Private',
        userId: json['user_id'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        encryptedId: json['encrypted_id'] ?? '',
        cards: (json['cards'] as List<dynamic>? ?? [])
            .map((c) => Card.fromJson(c))
            .toList(),
      );
    } catch (e, stacktrace) {
      print("\u274c Error parsing Board: $e");
      print("Data bermasalah: $json");
      print("\ud83d\udccc Stacktrace: $stacktrace");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "visibility": visibility,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "encrypted_id": encryptedId,
        "cards": List<dynamic>.from(cards.map((x) => x.toJson())),
      };
}

class Card {
  int id;
  int boardId;
  String? name;
  int position;
  DateTime createdAt;
  DateTime updatedAt;
  List<Task> tasks;

  Card({
    required this.id,
    required this.boardId,
    this.name,
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
        tasks: List<Task>.from(
          (json["tasks"] ?? []).map((x) => Task.fromJson(x)),
        ),
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
  DateTime? startTime;
  DateTime? endTime;
  DateTime createdAt;
  DateTime updatedAt;

  Task({
    required this.id,
    required this.cardId,
    required this.name,
    required this.description,
    required this.position,
    this.startTime,
    this.endTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    try {
      return Task(
        id: json["id"],
        cardId: json["card_id"],
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        position: json["position"],
        startTime: json["start_time"] != null
            ? DateTime.tryParse(json["start_time"])
            : null,
        endTime: json["end_time"] != null
            ? DateTime.tryParse(json["end_time"])
            : null,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
    } catch (e, stacktrace) {
      print("\u274c Error parsing Task: $e");
      print("Data Task bermasalah: $json");
      print("\ud83d\udccc Stacktrace: $stacktrace");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "card_id": cardId,
        "name": name,
        "description": description,
        "position": position,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
