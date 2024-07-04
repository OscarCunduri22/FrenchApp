// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, deprecated_member_use

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frenc_app/model/student.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:frenc_app/view/auth/student_login.view.dart';
import 'package:frenc_app/view/auth/tutor_dashboard.dart';
import 'package:frenc_app/widgets/auth/security_code_box.dart';
import 'package:frenc_app/widgets/auth/student_card.dart';
import 'package:frenc_app/widgets/character/gallo.dart';

class StudentListScreen extends StatefulWidget {
  final String tutorId;

  StudentListScreen({required this.tutorId});

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late Future<List<Map<String, dynamic>>> _studentsFuture;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _studentsFuture = _fetchStudents();
    Timer(const Duration(seconds: 2), () {
      AudioManager.effects().play('sound/studentlist.mp3');
    });
  }

  Future<List<Map<String, dynamic>>> _fetchStudents() async {
    final databaseRepository = DatabaseRepository();
    List<Map<String, dynamic>> studentsDocs =
        await databaseRepository.getStudentsByTutorId(widget.tutorId);

    List<Future<void>> imagePreloadFutures = studentsDocs.map((doc) {
      final studentData = Student.fromJson(doc['data']);
      return _preloadImage(studentData.imageUrl);
    }).toList();

    await Future.wait(imagePreloadFutures);
    return studentsDocs;
  }

  Future<void> _preloadImage(String imageUrl) {
    Completer<void> completer = Completer();
    Image.network(imageUrl)
        .image
        .resolve(const ImageConfiguration())
        .addListener(
      ImageStreamListener((ImageInfo image, bool synchronousCall) {
        completer.complete();
      }),
    );
    return completer.future;
  }

  void handleStudentTap(String studentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FruitGameScreen(studentId: studentId),
      ),
    );
  }

  void _showSecurityCodeDialog(Function onSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SecurityCodeDialog(onSuccess: onSuccess);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        _showSecurityCodeDialog(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TutorDashboardScreen(tutorName: '', studentCount: 2),
              ));
        });
        return false;
      },
      child: Scaffold(
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _studentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay estudiantes.'));
            } else {
              final studentsDocs = snapshot.data!;
              _isLoaded = true;
              return AnimatedOpacity(
                opacity: _isLoaded ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/onlyBg.jpg'),
                          fit: BoxFit.cover,
                        ),
                        color: Colors.white.withOpacity(0.9),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                        child: Container(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.75,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/auth/pizarra.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                              child: Text(
                                'Lista de estudiantes',
                                style: TextStyle(
                                  fontFamily: 'LoveDaysLoveFont',
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: ListView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: studentsDocs.length,
                                  itemBuilder: (context, index) {
                                    final studentData =
                                        studentsDocs[index]['data'];
                                    final studentId = studentsDocs[index]['id'];
                                    final student =
                                        Student.fromJson(studentData);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 32),
                                      child: StudentCard(
                                        student: student,
                                        onTap: handleStudentTap,
                                        studentId: studentId,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Image.asset(
                          'assets/images/icons/exit.png',
                          width: 64,
                          height: 64,
                        ),
                        onPressed: () {
                          _showSecurityCodeDialog(() {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TutorDashboardScreen(
                                      tutorName: '', studentCount: 2),
                                ));
                          });
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 12,
                      child: SizedBox(
                        height: 230,
                        width: 230,
                        child: GalloComponent.dancing(),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
