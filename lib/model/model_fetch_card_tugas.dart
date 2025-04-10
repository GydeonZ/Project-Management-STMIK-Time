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

    factory ModelFetchCardTugas.fromJson(Map<String, dynamic> json) => ModelFetchCardTugas(
        success: json["success"],
        boards: List<Board>.from(json["boards"].map((x) => Board.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "boards": List<dynamic>.from(boards.map((x) => x.toJson())),
    };
}

class Board {
    int id;
    String name;
    String encryptedId;
    List<Card> cards;

    Board({
        required this.id,
        required this.name,
        required this.encryptedId,
        required this.cards,
    });

    factory Board.fromJson(Map<String, dynamic> json) => Board(
        id: json["id"],
        name: json["name"],
        encryptedId: json["encrypted_id"],
        cards: List<Card>.from(json["cards"].map((x) => Card.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "encrypted_id": encryptedId,
        "cards": List<dynamic>.from(cards.map((x) => x.toJson())),
    };
}

class Card {
    int id;
    int boardId;
    String name;
    int position;
    List<Task> tasks;

    Card({
        required this.id,
        required this.boardId,
        required this.name,
        required this.position,
        required this.tasks,
    });

    factory Card.fromJson(Map<String, dynamic> json) => Card(
        id: json["id"],
        boardId: json["board_id"],
        name: json["name"],
        position: json["position"],
        tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "board_id": boardId,
        "name": name,
        "position": position,
        "tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
    };
}

class Task {
    int id;
    int cardId;
    String name;
    String? description;
    int position;
    DateTime? startTime;
    DateTime? endTime;

    Task({
        required this.id,
        required this.cardId,
        required this.name,
        required this.description,
        required this.position,
        required this.startTime,
        required this.endTime,
    });

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        cardId: json["card_id"],
        name: json["name"],
        description: json["description"],
        position: json["position"],
        startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]),
        endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "card_id": cardId,
        "name": name,
        "description": description,
        "position": position,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
    };
}
