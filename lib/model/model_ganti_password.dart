import 'dart:convert';

ModelGantiPassword modelGantiPasswordFromJson(Map<String, dynamic> str) =>
    ModelGantiPassword.fromJson(str);

String modelGantiPasswordToJson(ModelGantiPassword data) =>
    json.encode(data.toJson());

class ModelGantiPassword {
  String message;

  ModelGantiPassword({
    required this.message,
  });

  factory ModelGantiPassword.fromJson(Map<String, dynamic> json) =>
      ModelGantiPassword(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
