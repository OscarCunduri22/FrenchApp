import 'package:flutter/material.dart';
import 'package:frenc_app/view/auth/new_tutor_screen.dart';
import 'package:frenc_app/view/auth/student_list.dart';

class TutorLoginScreen extends StatelessWidget {
  const TutorLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_background.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 1,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(12, 2, 12, 2),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        labelStyle: TextStyle(
                          color: Colors.grey, // Placeholder gris
                        ),
                        filled: true, // Fondo blanco
                        fillColor: Colors.white, // Fondo blanco
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(
                          color: Colors.grey, // Placeholder gris
                        ),
                        filled: true, // Fondo blanco
                        fillColor: Colors.white, // Fondo blanco
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StudentList(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF016171), // Color de fondo #016171
                    ),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        color: Colors.white, // Texto blanco
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewTutorScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFF15E2F), // Color de fondo #016171
                    ),
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(
                        color: Colors.white, // Texto blanco
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: ElevatedButton(
                      onPressed:
                          _printHello, // Add a valid function or callback here
                      child: const Text("Hola"),
                    ),
                  ),
                  Text(
                    'AQUI VA EL GALLO',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _printHello() {
  print('Hello');
}
