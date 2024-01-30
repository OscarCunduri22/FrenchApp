import 'package:flutter/material.dart';
import 'package:frenc_app/data/dummy_data.dart';
import 'package:frenc_app/widgets/student_card.dart'; // Asegúrate de importar el widget correcto

class StudentList extends StatelessWidget {
  final String tutorEmail;

  const StudentList({Key? key, required this.tutorEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Buscar el tutor correspondiente en dummyTutors
    final tutor = dummyTutors.firstWhere((tutor) => tutor.email == tutorEmail);

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
                  return StudentCard(
                    name: student.name,
                    age: student.age,
                    imagePath: student.imageUrl,
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
