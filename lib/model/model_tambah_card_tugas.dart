import 'dart:convert';

ModelTambahCardTugas modelTambahCardTugasFromJson(Map <String, dynamic> str) =>
    ModelTambahCardTugas.fromJson(str);

String modelTambahCardTugasToJson(ModelTambahCardTugas data) =>
    json.encode(data.toJson());

class ModelTambahCardTugas {
    bool success;
    String message;
    Card card;

    ModelTambahCardTugas({
        required this.success,
        required this.message,
        required this.card,
    });

    factory ModelTambahCardTugas.fromJson(Map<String, dynamic> json) => ModelTambahCardTugas(
        success: json["success"],
        message: json["message"],
        card: json["card"] != null
            ? Card.fromJson(json["card"]) // Proses jika tidak null
            : Card(
                // Nilai default jika null
                name: "",
                boardId: "",
                position: 0,
                updatedAt: DateTime.now(),
                createdAt: DateTime.now(),
                id: 0,
              ),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "card": card.toJson(),
    };
}

class Card {
    String name;
    String boardId;
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
