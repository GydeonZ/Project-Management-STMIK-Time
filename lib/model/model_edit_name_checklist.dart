import 'dart:convert';

ModelUpdateNameChecklist modelUpdateNameChecklistFromJson(Map <String, dynamic> str) =>
    ModelUpdateNameChecklist.fromJson(str);

String modelUpdateNameChecklistToJson(ModelUpdateNameChecklist data) =>
    json.encode(data.toJson());

class ModelUpdateNameChecklist {
  bool success;
  String message;
  Checklist checklist;

  ModelUpdateNameChecklist({
    required this.success,
    required this.message,
    required this.checklist,
  });

  factory ModelUpdateNameChecklist.fromJson(Map<String, dynamic> json) =>
      ModelUpdateNameChecklist(
        success: json["success"],
        message: json["message"],
        checklist: Checklist.fromJson(json["checklist"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "checklist": checklist.toJson(),
      };
}

class Checklist {
  int id;
  int taskId;
  String name;
  bool isChecked;
  DateTime createdAt;
  DateTime updatedAt;

  Checklist({
    required this.id,
    required this.taskId,
    required this.name,
    required this.isChecked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) => Checklist(
        id: json["id"],
        taskId: json["task_id"],
        name: json["name"],
        isChecked: json["is_checked"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task_id": taskId,
        "name": name,
        "is_checked": isChecked,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
