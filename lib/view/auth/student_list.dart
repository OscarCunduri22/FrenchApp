// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:frenc_app/model/fruit.dart';
import 'package:frenc_app/view/auth/student_login.view.dart';
import 'package:frenc_app/widgets/student_card.dart';
import 'package:frenc_app/model/student.dart';
import 'package:frenc_app/repository/global.repository.dart';

class StudentListScreen extends StatelessWidget {
  final String tutorId;

  StudentListScreen({required this.tutorId});

  @override
  Widget build(BuildContext context) {
    final databaseRepository = DatabaseRepository();

    void handleStudentTap(String studentId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FruitGameScreen(studentId: studentId),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Primary Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/auth/studentlist_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered Secondary Background Container with transparency
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8, // 80% of the screen width
              heightFactor: 0.8, // 80% of the screen height
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/auth/book.png'),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.white.withOpacity(0.9), // Add transparency
                ),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: databaseRepository.getStudentsByTutorId(tutorId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No hay estudiantes.'));
                    } else {
                      final studentsDocs = snapshot.data!;
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                        ),
                        itemCount: studentsDocs.length,
                        itemBuilder: (context, index) {
                          final studentData = studentsDocs[index]['data'];
                          final studentId = studentsDocs[index]['id'];
                          final student = Student.fromJson(studentData);
                          return StudentCard(
                            student: student,
                            onTap: handleStudentTap,
                            studentId: studentId,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String studentId;

  const PlaceholderScreen({Key? key, required this.studentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
      ),
      body: Center(
        child: Text('Student ID: $studentId'),
      ),
    );
  }
}
