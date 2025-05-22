import 'dart:convert';

ModelEditJudulDetailTask modelEditJudulDetailTaskFromJson(Map <String, dynamic> str) =>
    ModelEditJudulDetailTask.fromJson(str);

String modelEditJudulDetailTaskToJson(ModelEditJudulDetailTask data) =>
    json.encode(data.toJson());

class ModelEditJudulDetailTask {
  bool success;
  String message;
  Task task;

  ModelEditJudulDetailTask({
    required this.success,
    required this.message,
    required this.task,
  });

  factory ModelEditJudulDetailTask.fromJson(Map<String, dynamic> json) =>
      ModelEditJudulDetailTask(
        success: json["success"],
        message: json["message"],
        task: Task.fromJson(json["task"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "task": task.toJson(),
      };
}

class Task {
  int id;
  int cardId;
  String name;
  String description;
  int position;
  DateTime startTime;
  DateTime endTime;
  DateTime createdAt;
  DateTime updatedAt;

  Task({
    required this.id,
    required this.cardId,
    required this.name,
    required this.description,
    required this.position,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        cardId: json["card_id"],
        name: json["name"],
        description: json["description"],
        position: json["position"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "card_id": cardId,
        "name": name,
        "description": description,
        "position": position,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
