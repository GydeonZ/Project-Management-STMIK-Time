import 'dart:convert';

ModelRegister modelRegisterFromJson(Map<String, dynamic> str) =>
    ModelRegister.fromJson(str);

String modelRegisterToJson(ModelRegister data) => json.encode(data.toJson());

class ModelRegister {
  String message;
  User user;

  ModelRegister({
    required this.message,
    required this.user,
  });

  factory ModelRegister.fromJson(Map<String, dynamic> json) => ModelRegister(
        message: json["message"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user": user.toJson(),
      };
}

class User {
  String name;
  String email;
  String role;
  dynamic nim;
  dynamic nidn;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  User({
    required this.name,
    required this.email,
    required this.role,
    required this.nim,
    required this.nidn,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        role: json["role"],
        nim: json["nim"],
        nidn: json["nidn"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "role": role,
        "nim": nim,
        "nidn": nidn,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
