import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/model/student.dart';
import 'package:frenc_app/widgets/auth/common_button_styles.dart';
import 'package:frenc_app/view/category_selection.dart';
import 'package:frenc_app/utils/user_tracking.dart';
import 'package:frenc_app/utils/user_provider.dart';

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
      body: FutureBuilder(
        future: Provider.of<UserTracking>(context, listen: false).loadTrackingData(studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Padding(
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
                      Provider.of<UserProvider>(context, listen: false).setCurrentStudent(studentId, student);
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
                        fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Progreso del Estudiante',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Consumer<UserTracking>(
                    builder: (context, userTracking, child) {
                      final totalGamesPlayed = userTracking.getTotalGamesPlayed();
                      final mostPlayedGame = userTracking.getMostPlayedGame();
                      return Row(
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Total de Juegos Jugados',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '$totalGamesPlayed',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Juego Más Jugado',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      mostPlayedGame,
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          }
        }
      ),
    );
  }
}
