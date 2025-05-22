import 'dart:convert';

ModelFetchAvailableBoardMember modelFetchAvailableBoardMemberFromJson(Map<String, dynamic> str) =>
    ModelFetchAvailableBoardMember.fromJson(str);

String modelFetchAvailableBoardMemberToJson(
        ModelFetchAvailableBoardMember data) =>
    json.encode(data.toJson());

class ModelFetchAvailableBoardMember {
  bool success;
  List<Datum> data;

  ModelFetchAvailableBoardMember({
    required this.success,
    required this.data,
  });

  factory ModelFetchAvailableBoardMember.fromJson(Map<String, dynamic> json) =>
      ModelFetchAvailableBoardMember(
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
