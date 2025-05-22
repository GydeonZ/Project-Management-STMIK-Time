import 'dart:convert';

ModelVerifikasiOtp modelVerifikasiOtpFromJson(Map<String, dynamic> str) =>
    ModelVerifikasiOtp.fromJson(str);

String modelVerifikasiOtpToJson(ModelVerifikasiOtp data) =>
    json.encode(data.toJson());

class ModelVerifikasiOtp {
  String message;
  String token;

  ModelVerifikasiOtp({
    required this.message,
    required this.token,
  });

  factory ModelVerifikasiOtp.fromJson(Map<String, dynamic> json) =>
      ModelVerifikasiOtp(
        message: json["message"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
      };
}
