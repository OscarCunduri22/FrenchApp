// views/student_list_screen.dart
// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:frenc_app/view/auth/student_login.view.dart';
import 'package:frenc_app/widgets/student_card.dart';
import 'package:frenc_app/model/student.dart';
import 'package:frenc_app/repository/global.repository.dart';

class StudentListScreen extends StatefulWidget {
  final String tutorId;

  StudentListScreen({required this.tutorId});

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  void handleStudentTap(String studentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FruitGameScreen(studentId: studentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final databaseRepository = DatabaseRepository();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/auth/classbg.webp'),
                fit: BoxFit.cover,
              ),
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.7,
              heightFactor: 0.7,
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('assets/images/auth/board1.png'),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.bottomCenter),
                  color: Colors.white.withOpacity(0.9),
                ),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future:
                      databaseRepository.getStudentsByTutorId(widget.tutorId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No hay estudiantes.'));
                    } else {
                      final studentsDocs = snapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Student List',
                              style: TextStyle(
                                fontFamily: 'LoveDaysLoveFont',
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                              scrollDirection: Axis.horizontal,
                              itemCount: studentsDocs.length,
                              itemBuilder: (context, index) {
                                final studentData = studentsDocs[index]['data'];
                                final studentId = studentsDocs[index]['id'];
                                final student = Student.fromJson(studentData);
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: StudentCard(
                                    student: student,
                                    onTap: handleStudentTap,
                                    studentId: studentId,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 50)
                        ],
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
