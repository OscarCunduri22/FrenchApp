// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:frenc_app/model/tutor.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/view/auth/create_student.dart';
import 'package:frenc_app/view/auth/student_list.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class TutorDashboardScreen extends StatelessWidget {
  final String tutorName;
  final int studentCount;

  final DatabaseRepository _databaseRepository = DatabaseRepository();

  TutorDashboardScreen({
    required this.tutorName,
    required this.studentCount,
  });

  @override
  Widget build(BuildContext context) {
    Tutor? currentUser = Provider.of<UserProvider>(context).currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('No user logged in'),
        ),
      );
    }

    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/auth/background_with_stars.png'), // Reemplaza con la ruta de tu imagen
              fit: BoxFit.cover,
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Container(
            color: Colors.black.withOpacity(0.1),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Bienvenido, $tutorName',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCard(
                      context,
                      'Prof. $tutorName',
                      'Estudiantes $studentCount',
                      Colors.white,
                      Icons.settings,
                      0,
                      'assets/images/Mattew.png',
                      onTap: () {
                        // Navegar a la pantalla de preferencias
                      },
                    ),
                    // _buildStudentCard(context, currentUser.email, 0.1),
                    _buildCard(
                      context,
                      'Estudiantes',
                      '',
                      Colors.white,
                      Icons.person,
                      0.1,
                      null,
                      onTap: () {
                        // Navegar a la pantalla de preferencias
                      },
                    ),
                    _buildCard(
                      context,
                      'Ajustes',
                      '',
                      Colors.white,
                      Icons.settings,
                      0.1,
                      null,
                      onTap: () {
                        // Navegar a la pantalla de preferencias
                      },
                    ),
                    _buildCard(
                      context,
                      'Juegos',
                      '',
                      Colors.white,
                      Icons.play_arrow,
                      0.1,
                      null,
                      onTap: () async {
                        String? tutorId = await _databaseRepository
                            .getTutorId(currentUser.email);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    StudentListScreen(tutorId: tutorId!)));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildStudentCard(BuildContext context, String email) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Card(
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              const Text(
                'Estudiantes',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$studentCount',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  String? tutorId = await _databaseRepository.getTutorId(email);
                  if (tutorId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreateStudentScreenHorizontal(tutorId: tutorId),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tutor ID not found'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Nuevo Estudiante'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String subtitle,
      Color color, IconData icon, double opacity, String? imagePath,
      {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        height: 200,
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(opacity),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (imagePath == null)
                        Icon(
                          icon,
                          size: 40,
                          color: Colors.white,
                        )
                      else
                        Image.asset(
                          imagePath,
                          width: 100,
                          height: 100,
                        ),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
