import 'dart:convert';

ModelUploadFile modelUploadFileFromJson(Map<String, dynamic> str) => ModelUploadFile.fromJson(str);

String modelUploadFileToJson(ModelUploadFile data) => json.encode(data.toJson());

class ModelUploadFile {
    bool success;
    String message;
    FileClass file;

    ModelUploadFile({
        required this.success,
        required this.message,
        required this.file,
    });

    factory ModelUploadFile.fromJson(Map<String, dynamic> json) => ModelUploadFile(
        success: json["success"],
        message: json["message"],
        file: FileClass.fromJson(json["file"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "file": file.toJson(),
    };
}

class FileClass {
    int userId;
    String displayName;
    String encryptedFilename;
    String originalFilename;
    String filePath;
    String mimeType;
    int fileSize;
    int taskId;
    DateTime updatedAt;
    DateTime createdAt;
    int id;

    FileClass({
        required this.userId,
        required this.displayName,
        required this.encryptedFilename,
        required this.originalFilename,
        required this.filePath,
        required this.mimeType,
        required this.fileSize,
        required this.taskId,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

    factory FileClass.fromJson(Map<String, dynamic> json) => FileClass(
        userId: json["user_id"],
        displayName: json["display_name"],
        encryptedFilename: json["encrypted_filename"],
        originalFilename: json["original_filename"],
        filePath: json["file_path"],
        mimeType: json["mime_type"],
        fileSize: json["file_size"],
        taskId: json["task_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "display_name": displayName,
        "encrypted_filename": encryptedFilename,
        "original_filename": originalFilename,
        "file_path": filePath,
        "mime_type": mimeType,
        "file_size": fileSize,
        "task_id": taskId,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
    };
}
