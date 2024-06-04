import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/student_card.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/model/student.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'dart:math';

class StudentListScreen extends StatelessWidget {
  final String tutorId;

  StudentListScreen({required this.tutorId});

  @override
  Widget build(BuildContext context) {
    final databaseRepository = DatabaseRepository();
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
    ];
    final Random random = Random();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Estudiantes'),
      ),
      body: Container(
        color: Colors.cyan, // Set a vibrant background color
        child: FutureBuilder<List<Student>?>(
          future: databaseRepository.getStudentsByTutorId(tutorId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay estudiantes.'));
            } else {
              final students = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final color = colors[random.nextInt(colors.length)];
                  return StudentCard(
                      student: students[index], backgroundColor: color);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
