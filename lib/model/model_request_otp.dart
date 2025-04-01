import 'dart:convert';

ModelRequestOtp modelRequestOtpFromJson(Map<String, dynamic> str) =>
    ModelRequestOtp.fromJson(str);

String modelRequestOtpToJson(ModelRequestOtp data) =>
    json.encode(data.toJson());

class ModelRequestOtp {
  String message;

  ModelRequestOtp({
    required this.message,
  });

  factory ModelRequestOtp.fromJson(Map<String, dynamic> json) =>
      ModelRequestOtp(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
