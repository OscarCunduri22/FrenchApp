import 'package:flutter/material.dart';
import 'package:frenc_app/model/student.dart';
import 'package:frenc_app/widgets/auth/common_button_styles.dart'; // Importar estilos de botones comunes
import 'package:frenc_app/view/game_selection.dart';
import 'package:frenc_app/view/category_selection.dart'; // Importar la pantalla de selección de categoría

class StudentDetailScreen extends StatelessWidget {
  final Student student;
  final String studentId;

  const StudentDetailScreen({required this.student, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Estudiante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(student.imageUrl),
                      radius: 40,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Juegos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategorySelectionScreen(),
                  ),
                );
              },
              style: CommonButtonStyles.primaryButtonStyle,
              child: const Text(
                'Jugar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
