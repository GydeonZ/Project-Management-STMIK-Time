import 'dart:convert';

ModelTambahTugas modelTambahTugasFromJson(Map <String, dynamic>str) =>
    ModelTambahTugas.fromJson(str);

String modelTambahTugasToJson(ModelTambahTugas data) =>
    json.encode(data.toJson());

class ModelTambahTugas {
  bool success;
  String message;
  Task task;

  ModelTambahTugas({
    required this.success,
    required this.message,
    required this.task,
  });

  factory ModelTambahTugas.fromJson(Map<String, dynamic> json) =>
      ModelTambahTugas(
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
  String name;
  dynamic description;
  String cardId;
  int position;
  dynamic startTime;
  dynamic endTime;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Task({
    required this.name,
    required this.description,
    required this.cardId,
    required this.position,
    required this.startTime,
    required this.endTime,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        name: json["name"],
        description: json["description"],
        cardId: json["card_id"],
        position: json["position"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "card_id": cardId,
        "position": position,
        "start_time": startTime,
        "end_time": endTime,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
