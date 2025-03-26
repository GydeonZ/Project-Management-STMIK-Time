import 'dart:convert';

ModelForgotPassword modelForgotPasswordFromJson(Map <String, dynamic>str) =>
    ModelForgotPassword.fromJson(str);

String modelForgotPasswordToJson(ModelForgotPassword data) =>
    json.encode(data.toJson());

class ModelForgotPassword {
  String message;
  String status;

  ModelForgotPassword({
    required this.message,
    required this.status,
  });

  factory ModelForgotPassword.fromJson(Map<String, dynamic> json) =>
      ModelForgotPassword(
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
      };
}
