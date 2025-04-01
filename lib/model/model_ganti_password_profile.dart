import 'dart:convert';

ModelGantiPasswordProfile modelGantiPasswordProfileFromJson(Map <String, dynamic> str) =>
    ModelGantiPasswordProfile.fromJson(str);

String modelGantiPasswordProfileToJson(ModelGantiPasswordProfile data) =>
    json.encode(data.toJson());

class ModelGantiPasswordProfile {
  String status;
  String message;

  ModelGantiPasswordProfile({
    required this.status,
    required this.message,
  });

  factory ModelGantiPasswordProfile.fromJson(Map<String, dynamic> json) =>
      ModelGantiPasswordProfile(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
