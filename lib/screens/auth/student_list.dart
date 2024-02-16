import 'package:flutter/material.dart';
import 'package:frenc_app/data/dummy_data.dart';
import 'package:frenc_app/screens/numbers/cards_game_screen.dart';
import 'package:frenc_app/widgets/student_card.dart';

class StudentList extends StatelessWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tutor =
        dummyTutors.firstWhere((tutor) => tutor.email == 'tutor1@fa.com');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Estudiantes'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.blue.shade200],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lista de Estudiantes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: tutor.students.map((student) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StudentLogin(),
                          ),
                        );
                      },
                      child: StudentCard(
                        name: student.name,
                        age: student.age,
                        imagePath: student.imageUrl,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
