import 'package:flutter/material.dart';
import 'package:frenc_app/data/dummy_data.dart';
import 'package:frenc_app/screens/numbers/cards_game_screen.dart';
import 'package:frenc_app/widgets/student_card.dart';

class StudentList extends StatelessWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Buscar el tutor correspondiente en dummyTutors
    final tutor =
        dummyTutors.firstWhere((tutor) => tutor.email == 'tutor1@fa.com');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Estudiantes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lista de Estudiantes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
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
                            builder: (context) => const CardGame()),
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
    );
  }
}
