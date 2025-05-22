import 'dart:convert';

ModelUpdateProfile modelUpdateProfileFromJson(Map<String, dynamic> str) =>
    ModelUpdateProfile.fromJson(str);

String modelUpdateProfileToJson(ModelUpdateProfile data) =>
    json.encode(data.toJson());

class ModelUpdateProfile {
  String status;
  String message;
  Data data;

  ModelUpdateProfile({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ModelUpdateProfile.fromJson(Map<String, dynamic> json) =>
      ModelUpdateProfile(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int id;
  String name;
  String email;
  DateTime emailVerifiedAt;
  int active;
  String role;
  String? nim; // Ubah menjadi nullable
  String? nidn; // Ubah menjadi nullable
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.active,
    required this.role,
    this.nim, // Parameter opsional
    this.nidn, // Parameter opsional
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
        active: json["active"],
        role: json["role"],
        nim: json["nim"] ?? "", // Berikan default string kosong jika null
        nidn: json["nidn"] ?? "", // Berikan default string kosong jika null
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt.toIso8601String(),
        "active": active,
        "role": role,
        "nim": nim ?? "", // Gunakan string kosong jika nim null
        "nidn": nidn ?? "", // Gunakan string kosong jika nidn null
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
