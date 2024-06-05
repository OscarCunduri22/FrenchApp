// widgets/student_card.dart
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
        child: Container(
          width: 120,
          height: 180,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/auth/book.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
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
                    fontFamily: 'ShortBabyFont',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  student.group,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'LoveDaysLoveFont',
                    color: Colors.black.withOpacity(0.6),
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
