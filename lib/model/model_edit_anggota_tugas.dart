import 'dart:convert';

ModelEditAnggotaTugas modelEditAnggotaTugasFromJson(Map <String, dynamic> str) =>
    ModelEditAnggotaTugas.fromJson(str);

String modelEditAnggotaTugasToJson(ModelEditAnggotaTugas data) =>
    json.encode(data.toJson());

class ModelEditAnggotaTugas {
  bool success;
  String message;

  ModelEditAnggotaTugas({
    required this.success,
    required this.message,
  });

  factory ModelEditAnggotaTugas.fromJson(Map<String, dynamic> json) =>
      ModelEditAnggotaTugas(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
