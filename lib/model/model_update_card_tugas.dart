import 'dart:convert';

ModelUpdateCardTugas modelUpdateCardTugasFromJson(Map<String, dynamic> str) =>
    ModelUpdateCardTugas.fromJson(str);

String modelUpdateCardTugasToJson(ModelUpdateCardTugas data) =>
    json.encode(data.toJson());

class ModelUpdateCardTugas {
  bool success;
  String message;
  Card card;

  ModelUpdateCardTugas({
    required this.success,
    required this.message,
    required this.card,
  });

  factory ModelUpdateCardTugas.fromJson(Map<String, dynamic> json) =>
      ModelUpdateCardTugas(
        success: json["success"],
        message: json["message"],
        card: Card.fromJson(json["card"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "card": card.toJson(),
      };
}

class Card {
  String name;
  int boardId;
  int position;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Card({
    required this.name,
    required this.boardId,
    required this.position,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        name: json["name"],
        boardId: json["board_id"],
        position: json["position"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "board_id": boardId,
        "position": position,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
