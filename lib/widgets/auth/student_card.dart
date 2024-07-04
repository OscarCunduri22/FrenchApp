import 'package:flutter/material.dart';
import 'package:frenc_app/model/student.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final String studentId;
  final void Function(String studentId) onTap;

  const StudentCard({
    required this.student,
    required this.studentId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(studentId),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              child: Center(
                child: ClipOval(
                  child: Image.network(
                    student.imageUrl,
                    height: 100, // Adjust height and width as needed
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                student.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Group: ${student.group}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
