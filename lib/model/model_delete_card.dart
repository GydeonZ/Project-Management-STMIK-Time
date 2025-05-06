import 'dart:convert';

ModelDeleteCard modelDeleteCardFromJson(Map<String, dynamic> str) =>
    ModelDeleteCard.fromJson(str);

String modelDeleteCardToJson(ModelDeleteCard data) =>
    json.encode(data.toJson());

class ModelDeleteCard {
  bool success;
  String message;

  ModelDeleteCard({
    required this.success,
    required this.message,
  });

  factory ModelDeleteCard.fromJson(Map<String, dynamic> json) =>
      ModelDeleteCard(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}