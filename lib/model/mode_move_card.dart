import 'dart:convert';

ModelMoveCard modelMoveCardFromJson(Map<String, dynamic> str) =>
    ModelMoveCard.fromJson(str);

String modelMoveCardToJson(ModelMoveCard data) => json.encode(data.toJson());

class ModelMoveCard {
  bool success;
  String message;
  Card card;

  ModelMoveCard({
    required this.success,
    required this.message,
    required this.card,
  });

  factory ModelMoveCard.fromJson(Map<String, dynamic> json) => ModelMoveCard(
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
