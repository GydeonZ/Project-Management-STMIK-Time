import 'dart:convert';

ModelDeleteBoard modelDeleteBoardFromJson(Map<String, dynamic> str) =>
    ModelDeleteBoard.fromJson(str);

String modelDeleteBoardToJson(ModelDeleteBoard data) =>
    json.encode(data.toJson());

class ModelDeleteBoard {
  bool success;
  String message;

  ModelDeleteBoard({
    required this.success,
    required this.message,
  });

  factory ModelDeleteBoard.fromJson(Map<String, dynamic> json) =>
      ModelDeleteBoard(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
