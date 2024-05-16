import 'package:cloud_firestore/cloud_firestore.dart';

class Tutor {
  String name;
  String email;
  String password;
  int code;

  Tutor({
    required this.name,
    required this.email,
    required this.password,
    required this.code,
  });

  Tutor.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          email: json['email']! as String,
          password: json['password']! as String,
          code: json['code']! as int,
        );

  Tutor copyWith({
    String? name,
    String? email,
    String? password,
    int? code,
  }) {
    return Tutor(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      code: code ?? this.code,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'code': code,
    };
  }
}
