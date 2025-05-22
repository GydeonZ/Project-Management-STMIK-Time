import 'dart:convert';

ModelDeleteFiles modelDeleteFilesFromJson(Map<String, dynamic> str) =>
    ModelDeleteFiles.fromJson(str);

String modelDeleteFilesToJson(ModelDeleteFiles data) =>
    json.encode(data.toJson());

class ModelDeleteFiles {
  bool success;
  String message;
  String fileId;

  ModelDeleteFiles({
    required this.success,
    required this.message,
    required this.fileId,
  });

  factory ModelDeleteFiles.fromJson(Map<String, dynamic> json) =>
      ModelDeleteFiles(
        success: json["success"],
        message: json["message"],
        fileId: json["file_id"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "file_id": fileId,
      };
}
