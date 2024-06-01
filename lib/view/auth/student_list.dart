import 'package:flutter/material.dart';
import 'package:frenc_app/model/tutor.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:provider/provider.dart';

class StudentList extends StatelessWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tutor? currentUser = Provider.of<UserProvider>(context).currentUser;

    return Text(
        'Lista de Estudiantes ${currentUser == null ? 'No hay usuario' : currentUser.name}');
    /*return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Lista de Estudiantes'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
        backgroundColor: Colors.black.withOpacity(0.5),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondo_bandera.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: students.map((student) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StudentLogin(),
                              ),
                            );
                          },
                          child: StudentCard(
                            name: student.name,
                            age: student.age,
                            imagePath: student.imageUrl,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: FloatingActionButton(
                onPressed: () {
                  // Agrega aquí la lógica para el botón circular
                },
                backgroundColor: Colors.lightGreen,
                child: const Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );*/
  }
}
