import 'dart:convert';

ModelSendFcm modelSendFcmFromJson(Map<String, dynamic> str) =>
    ModelSendFcm.fromJson(str);

String modelSendFcmToJson(ModelSendFcm data) => json.encode(data.toJson());

class ModelSendFcm {
  bool success;
  String message;
  Data data;

  ModelSendFcm({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ModelSendFcm.fromJson(Map<String, dynamic> json) => ModelSendFcm(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int userId;
  String deviceType;
  String deviceToken;

  Data({
    required this.userId,
    required this.deviceType,
    required this.deviceToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        deviceType: json["device_type"],
        deviceToken: json["device_token"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "device_type": deviceType,
        "device_token": deviceToken,
      };
}
