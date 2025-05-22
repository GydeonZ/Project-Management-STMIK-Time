import 'dart:convert';

ModelAddChecklist modelAddChecklistFromJson(Map<String, dynamic> str) =>
    ModelAddChecklist.fromJson(str);

String modelAddChecklistToJson(ModelAddChecklist data) =>
    json.encode(data.toJson());

class ModelAddChecklist {
  bool success;
  String message;
  Checklist checklist;

  ModelAddChecklist({
    required this.success,
    required this.message,
    required this.checklist,
  });

  factory ModelAddChecklist.fromJson(Map<String, dynamic> json) =>
      ModelAddChecklist(
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
  String name;
  bool isChecked;
  int taskId;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Checklist({
    required this.name,
    required this.isChecked,
    required this.taskId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) => Checklist(
        name: json["name"],
        isChecked: json["is_checked"],
        taskId: json["task_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "is_checked": isChecked,
        "task_id": taskId,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
