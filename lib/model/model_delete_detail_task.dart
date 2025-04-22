import 'dart:convert';

ModelDeleteDetailTask modelDeleteDetailTaskFromJson(Map <String, dynamic> str) =>
    ModelDeleteDetailTask.fromJson(str);

String modelDeleteDetailTaskToJson(ModelDeleteDetailTask data) =>
    json.encode(data.toJson());

class ModelDeleteDetailTask {
  bool success;
  String message;

  ModelDeleteDetailTask({
    required this.success,
    required this.message,
  });

  factory ModelDeleteDetailTask.fromJson(Map<String, dynamic> json) =>
      ModelDeleteDetailTask(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
