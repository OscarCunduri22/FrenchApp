// views/student_list_screen.dart
// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:frenc_app/view/auth/student_login.view.dart';
import 'package:frenc_app/widgets/auth/student_card.dart';
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
                image: AssetImage('assets/images/auth/aula.png'),
                fit: BoxFit.cover,
              ),
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              widthFactor: 0.9,
              heightFactor: 0.8,
              child: Column(
                children: [
                  Container(
                    width: 600,
                    height: 300,
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/auth/pizarra.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(8, 32, 8, 8),
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
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: databaseRepository
                                  .getStudentsByTutorId(widget.tutorId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Center(
                                      child: Text('No hay estudiantes.'));
                                } else {
                                  final studentsDocs = snapshot.data!;

                                  return ListView.builder(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 0, 20, 10),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: studentsDocs.length,
                                    itemBuilder: (context, index) {
                                      final studentData =
                                          studentsDocs[index]['data'];
                                      final studentId =
                                          studentsDocs[index]['id'];
                                      final student =
                                          Student.fromJson(studentData);
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            24, 0, 8, 0),
                                        child: StudentCard(
                                          student: student,
                                          onTap: handleStudentTap,
                                          studentId: studentId,
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
