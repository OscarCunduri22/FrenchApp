// ignore_for_file: use_build_context_synchronously, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/utils/dialog_manager.dart';
import 'package:frenc_app/utils/validator.dart';
import 'package:frenc_app/view/auth/register_tutor.view.dart';
import 'package:frenc_app/view/auth/tutor_dashboard.dart';
import 'package:frenc_app/widgets/character/gallo.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';
import 'package:provider/provider.dart';
import 'package:frenc_app/model/tutor.dart';
import 'package:frenc_app/utils/user_provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      final snackBar = SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Login Failed',
          message: e.message ?? 'Unknown error',
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
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenSize.width,
            height: screenSize.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/global/clouds-creditsbg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Center(
                            child: CustomTextWidget(
                              text: 'LudoFrench',
                              type: TextType.Title,
                              fontSize: 44,
                              fontWeight: FontWeight.w200,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Image.asset(
                            'assets/images/icons/exit.png',
                            width: 32,
                            height: 32,
                          ),
                          onPressed: () {
                            DialogManager.showExitConfirmationDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _buildLoginForm(context),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: GalloComponent.dancing()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomTextWidget(
          text: "Iniciar Sesión",
          type: TextType.Subtitle,
          fontSize: 30.0,
          color: ColorType.Secondary,
        ),
        const SizedBox(height: 4),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Correo Electrónico',
            labelStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: 'Contraseña',
            labelStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            Validator emailValidator = Validator(emailController.text)
                .checkEmpty()
                .checkEmail()
                .checkInjection();

            Validator passwordValidator = Validator(passwordController.text)
                .checkEmail()
                .checkEmpty()
                .checkInjection();

            if (!emailValidator.isValid() && !passwordValidator.isValid()) {
              final snackBar = SnackBar(
                content: AwesomeSnackbarContent(
                  title: 'Error! Datos inválidos',
                  message: 'Intenta nuevamente',
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
              setState(() {
                isLoading = false;
              });
              return;
            }

            setState(() {
              isLoading = true;
            });

            try {
              String? tutorId =
                  await databaseRepository.getTutorId(emailController.text);
              Tutor? tutor = await databaseRepository.loginTutor(
                emailController.text,
                passwordController.text,
              );

              if (tutorId != null && tutor != null) {
                int? studentCount =
                    await databaseRepository.getStudentsCountByTutorId(tutorId);

                setState(() {
                  isLoading = false;
                });

                final snackBar = SnackBar(
                  content: AwesomeSnackbarContent(
                    title: 'Login Successful',
                    message: 'You have successfully logged in! Redirecting...',
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
                  Provider.of<UserProvider>(context, listen: false)
                      .setCurrentUser(tutor);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TutorDashboardScreen(
                        tutorName: tutor.name,
                        studentCount: studentCount ?? 0,
                      ),
                    ),
                  );
                }
              } else {
                setState(() {
                  isLoading = false;
                });

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
            } catch (e) {
              setState(() {
                isLoading = false;
              });

              final snackBar = SnackBar(
                content: AwesomeSnackbarContent(
                  title: 'Login Failed',
                  message: 'An error occurred!',
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
        const SizedBox(height: 4),
        ElevatedButton(
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
      ],
    );
  }
}
