import 'dart:convert';

ModelDeleteBoardMember modelDeleteBoardMemberFromJson(Map<String, dynamic> str) =>
    ModelDeleteBoardMember.fromJson(str);

String modelDeleteBoardMemberToJson(ModelDeleteBoardMember data) =>
    json.encode(data.toJson());

class ModelDeleteBoardMember {
  String message;
  bool success;

  ModelDeleteBoardMember({
    required this.message,
    required this.success,
  });

  factory ModelDeleteBoardMember.fromJson(Map<String, dynamic> json) =>
      ModelDeleteBoardMember(
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
      };
}
