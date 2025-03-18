import 'dart:convert';

ModelSignIn modelSignInFromJson(Map <String, dynamic> str) =>
    ModelSignIn.fromJson(str);

String modelSignInToJson(ModelSignIn data) => json.encode(data.toJson());

class ModelSignIn {
  String message;
  User user;
  String token;

  ModelSignIn({
    required this.message,
    required this.user,
    required this.token,
  });

  factory ModelSignIn.fromJson(Map<String, dynamic> json) => ModelSignIn(
        message: json["message"],
        user: User.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user": user.toJson(),
        "token": token,
      };
}

class User {
  String id;
  String name;
  String email;
  String role;
  dynamic nim;
  dynamic nidn;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.nim,
    required this.nidn,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        nim: json["nim"],
        nidn: json["nidn"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "nim": nim,
        "nidn": nidn,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
