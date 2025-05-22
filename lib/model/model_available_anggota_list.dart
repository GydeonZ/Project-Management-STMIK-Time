import 'dart:convert';

ModelAvailableAnggotaList modelAvailableAnggotaListFromJson(Map<String, dynamic> str) =>
    ModelAvailableAnggotaList.fromJson(str);

String modelAvailableAnggotaListToJson(ModelAvailableAnggotaList data) =>
    json.encode(data.toJson());

class ModelAvailableAnggotaList {
  bool success;
  List<Datum> data;

  ModelAvailableAnggotaList({
    required this.success,
    required this.data,
  });

  factory ModelAvailableAnggotaList.fromJson(Map<String, dynamic> json) =>
      ModelAvailableAnggotaList(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String name;
  String email;
  String role;

  Datum({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
      };
}
