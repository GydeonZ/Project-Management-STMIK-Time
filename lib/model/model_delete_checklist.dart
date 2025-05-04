import 'dart:convert';

ModelDeleteChecklist modelDeleteChecklistFromJson(Map <String, dynamic> str) =>
    ModelDeleteChecklist.fromJson(str);

String modelDeleteChecklistToJson(ModelDeleteChecklist data) =>
    json.encode(data.toJson());

class ModelDeleteChecklist {
  bool success;
  String message;
  String checklistId;

  ModelDeleteChecklist({
    required this.success,
    required this.message,
    required this.checklistId,
  });

  factory ModelDeleteChecklist.fromJson(Map<String, dynamic> json) =>
      ModelDeleteChecklist(
        success: json["success"],
        message: json["message"],
        checklistId: json["checklist_id"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "checklist_id": checklistId,
      };
}
