import 'package:flutter/material.dart';
import 'package:frenc_app/data/dummy_data.dart';
import 'package:frenc_app/screens/student_list.dart'; // Asegúrate de importar el archivo correcto

class TutorLoginScreen extends StatelessWidget {
  const TutorLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                // Verificar si el tutor existe en la lista
                var tutor = dummyTutors.firstWhere((tutor) =>
                        tutor.email == email && tutor.password == password) ??
                    null; // Si no se encuentra el tutor, asignar null

                if (tutor != null) {
                  // Navegar a la página StudentList y pasar el correo electrónico del tutor
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentList(tutorEmail: email),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Correo electrónico o contraseña incorrectos'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
