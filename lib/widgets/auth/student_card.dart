import 'package:flutter/material.dart';
import 'package:frenc_app/model/student.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final String studentId;
  final Function(String) onTap;

  const StudentCard({
    Key? key,
    required this.student,
    required this.studentId,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(studentId),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), color: Colors.white),
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
              const SizedBox(height: 8),
              Text(
                student.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LoveDaysLoveFont',
                  color: Color(0xFF016171),
                ),
              ),
              Text(
                student.group,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'LoveDaysLoveFont',
                  color: Color(0xFFF15E2F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
