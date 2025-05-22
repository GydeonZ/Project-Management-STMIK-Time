import 'dart:convert';

ModelResetPassword modelResetPasswordFromJson(Map<String, dynamic> str) =>
    ModelResetPassword.fromJson(str);

String modelResetPasswordToJson(ModelResetPassword data) =>
    json.encode(data.toJson());

class ModelResetPassword {
  String status;
  String message;

  ModelResetPassword({
    required this.status,
    required this.message,
  });

  factory ModelResetPassword.fromJson(Map<String, dynamic> json) =>
      ModelResetPassword(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
