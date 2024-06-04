import 'package:flutter/material.dart';
import 'package:frenc_app/model/student.dart';
import 'dart:math';

class StudentCard extends StatelessWidget {
  final Student student;
  final Color backgroundColor;

  const StudentCard(
      {Key? key, required this.student, required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.all(4.0), // Reduced margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Adjusted border radius
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0), // Reduced padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                student.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              student.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Grupo: ${student.group}',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
