import 'package:flutter/material.dart';
import 'package:frenc_app/model/tutor.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/view/auth/create_student.dart';
import 'package:provider/provider.dart';

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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/auth/ludofrench_bg.png'), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
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
                    _buildStudentCard(context, currentUser.email),
                    _buildCard(
                      context,
                      'Preferencias',
                      '',
                      Colors.green,
                      Icons.settings,
                      onTap: () {
                        // Navigate to preferences screen
                      },
                    ),
                    _buildCard(
                      context,
                      'Iniciar Juego',
                      '',
                      Colors.red,
                      Icons.play_arrow,
                      onTap: () {
                        // Navigate to game screen
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
                        builder: (context) => CreateStudentScreenHorizontal(
                            tutorId: tutorId), // pass the actual tutor ID
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
      Color color, IconData icon,
      {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        child: Card(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
