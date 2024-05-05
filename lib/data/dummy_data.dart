import 'package:frenc_app/model/student.dart';
import 'package:frenc_app/model/tutor.dart';

export 'dummy_data.dart';

final List<Tutor> dummyTutors = [
  Tutor(
    name: 'Tutor inicial 1',
    imageUrl: 'assets/images/tutor1.jpg',
    email: 'tutor1@fa.com',
    password: '123',
    students: [
      Student(
        name: 'Student inicial 1',
        age: 2,
      ),
      Student(
        name: 'Student inicial 2',
        age: 3,
      ),
      Student(
        name: 'Student inicial 3',
        age: 4,
      ),
      Student(
        name: 'Student inicial 4',
        age: 5,
      ),
      Student(
        name: 'Student inicial 5',
        age: 10,
      ),
    ],
  ),
  Tutor(
    name: 'Tutor inicial 2',
    imageUrl: '',
    email: 'tutor2@fa.com',
    password: '123',
    students: [],
  ),
];
