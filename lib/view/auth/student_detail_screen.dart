import 'package:flutter/material.dart';
import 'package:frenc_app/view/auth/student_login.view.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/model/student.dart';
import 'package:frenc_app/widgets/auth/common_button_styles.dart';
import 'package:frenc_app/view/category_selection.dart';
import 'package:frenc_app/utils/user_tracking.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:fl_chart/fl_chart.dart';

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
            return SingleChildScrollView(
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
                          builder: (context) => FruitGameScreen(studentId: studentId),
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
                      final mostPlayedCategory = userTracking.getMostPlayedCategory();
                      final gamesPlayedPerCategory = userTracking.getGamesPlayedPerCategory();
                      final topThreeGames = userTracking.getTopThreeGames();
                      return Column(
                        children: [
                          Row(
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
                                          'Categoría Más Jugada',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          mostPlayedCategory,
                                          style: const TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Juegos por Categoría',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Table(
                            border: TableBorder.all(),
                            children: [
                              TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Categoría',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Juegos Jugados',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ...gamesPlayedPerCategory.entries.map((entry) {
                                return TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(entry.key),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${entry.value}'),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Top 3 Juegos Más Jugados',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 200,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                barGroups: topThreeGames.map((entry) {
                                  return BarChartGroupData(
                                    x: entry.key.hashCode,
                                    barRods: [
                                      BarChartRodData(
                                        toY: entry.value.toDouble(),
                                        color: Colors.blue,
                                        width: 30, // Adjust the width here to make bars wider or narrower
                                      ),
                                    ],
                                    showingTooltipIndicators: [0],
                                  );
                                }).toList(),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final game = topThreeGames.firstWhere((entry) => entry.key.hashCode == value.toInt()).key;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4.0), // Adjust horizontal padding to space out bars
                                          child: Text(game, style: TextStyle(fontSize: 10), textAlign: TextAlign.center),
                                        );
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: true),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                gridData: FlGridData(show: false),
                                barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipPadding: const EdgeInsets.all(8.0),
                                    tooltipRoundedRadius: 4,
                                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                      return BarTooltipItem(
                                        rod.toY.toString(),
                                        const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                groupsSpace: 10, // Adjust group space to bring bars closer together
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
