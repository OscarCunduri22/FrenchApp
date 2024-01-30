import 'package:frenc_app/models/student.dart';
import 'package:frenc_app/models/user.dart';

class Tutor extends User {
  String email;
  String password;
  List<Student> students;

  Tutor(
      {required String name,
      String? imageUrl,
      required this.email,
      required this.password,
      required this.students})
      : super(name: name, imageUrl: imageUrl);
}
