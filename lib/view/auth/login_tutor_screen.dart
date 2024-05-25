// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frenc_app/view/auth/tutor_dashboard.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/model/tutor.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:frenc_app/view/auth/register_tutor.view.dart';
import 'package:frenc_app/view/auth/student_list.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class TutorLoginScreen extends StatefulWidget {
  TutorLoginScreen({Key? key}) : super(key: key);

  @override
  _TutorLoginScreenState createState() => _TutorLoginScreenState();
}

class _TutorLoginScreenState extends State<TutorLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseRepository databaseRepository = DatabaseRepository();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/auth/login_bg.png'),
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
                      const SizedBox(height: 1),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
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
                      const SizedBox(height: 3),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
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
                          obscureText: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            Tutor? tutor = await databaseRepository.loginTutor(
                              emailController.text,
                              passwordController.text,
                            );
                            setState(() {
                              isLoading = false;
                            });
                            if (tutor != null) {
                              final snackBar = SnackBar(
                                content: AwesomeSnackbarContent(
                                  title: 'Login Successful',
                                  message:
                                      'You have successfully logged in! Redirecting...',
                                  contentType: ContentType.success,
                                  messageFontSize: 10,
                                  titleFontSize: 12,
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              );
                              ScaffoldMessenger.of(context)
                                ..hideCurrentMaterialBanner()
                                ..showSnackBar(snackBar);
                              await Future.delayed(const Duration(seconds: 3));
                              if (mounted) {
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .setCurrentUser(tutor);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TutorDashboardScreen(
                                            tutorName: tutor.name,
                                            studentCount: 2,
                                          )),
                                );
                              }
                            } else {
                              final snackBar = SnackBar(
                                content: AwesomeSnackbarContent(
                                  title: 'Login Failed',
                                  message: 'Invalid credentials!',
                                  contentType: ContentType.failure,
                                  messageFontSize: 10,
                                  titleFontSize: 12,
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              );
                              ScaffoldMessenger.of(context)
                                ..hideCurrentMaterialBanner()
                                ..showSnackBar(snackBar);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF016171),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Iniciar Sesión',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF15E2F),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Registrarse',
                            style: TextStyle(color: Colors.white, fontSize: 18),
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
                          child: Text("Hola"),
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
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void _printHello() {
  // Add a valid function or callback here
}
