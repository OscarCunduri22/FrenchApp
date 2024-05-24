import 'package:cloud_firestore/cloud_firestore.dart';

class Tutor {
  String name;
  String username;
  String email;
  String password;
  int code;

  Tutor({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.code,
  });

  Tutor.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          username: json['username']! as String,
          email: json['email']! as String,
          password: json['password']! as String,
          code: json['code']! as int,
        );

  Tutor copyWith({
    String? name,
    String? username,
    String? email,
    String? password,
    int? code,
  }) {
    return Tutor(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      code: code ?? this.code,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'code': code,
    };
  }
}
