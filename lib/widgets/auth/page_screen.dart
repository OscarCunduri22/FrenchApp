// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:frenc_app/model/tutor.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/view/auth/login_tutor_screen.dart';
import 'package:frenc_app/view/auth/student_list.dart';

class PageScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final int pageIndex;
  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController codeController;

  const PageScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.pageIndex,
    required this.nameController,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.codeController,
  });

  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  bool isLoading = false;
  final DatabaseRepository databaseRepository = DatabaseRepository();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Container(), // Placeholder for the character
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.pageIndex == 0) ...[
                    TextField(
                      controller: widget.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
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
                    const SizedBox(height: 6),
                    TextField(
                      controller: widget.usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Usuario',
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
                    const SizedBox(height: 6),
                    TextField(
                      controller: widget.emailController,
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
                  ] else if (widget.pageIndex == 1) ...[
                    TextField(
                      controller: widget.passwordController,
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
                    const SizedBox(height: 16),
                    TextField(
                      controller: widget.confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirmar Contraseña',
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
                  ] else if (widget.pageIndex == 2) ...[
                    TextField(
                      controller: widget.codeController,
                      maxLength: 4,
                      decoration: const InputDecoration(
                        labelText: 'Codigo',
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
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await Future.delayed(const Duration(seconds: 2));
                        bool success = await databaseRepository.addTutor(
                          Tutor(
                            name: widget.nameController.text,
                            username: widget.usernameController.text,
                            email: widget.emailController.text,
                            password: widget.passwordController.text,
                            code: int.parse(widget.codeController.text),
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                        if (success) {
                          final snackBar = SnackBar(
                            content: AwesomeSnackbarContent(
                              title: 'Registration Successful',
                              message:
                                  'You have successfully registered! Redirecting...',
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TutorLoginScreen(),
                              ),
                            );
                          }
                        } else {
                          final snackBar = SnackBar(
                            content: AwesomeSnackbarContent(
                              title: 'Registration Failed',
                              message: 'Something went wrong!',
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
                        'Registrar',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
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
