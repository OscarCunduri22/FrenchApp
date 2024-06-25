import 'dart:async';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:frenc_app/model/tutor.dart';
import 'package:frenc_app/repository/global.repository.dart';
import 'package:frenc_app/utils/audio_manager.dart';
import 'package:frenc_app/utils/validator.dart';
import 'package:frenc_app/view/auth/login_tutor_screen.dart';
import 'package:frenc_app/widgets/character/gallo.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';

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
  final Function setLoading;

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
    required this.setLoading,
  });

  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  bool isLoading = false;
  String text = '';
  final DatabaseRepository databaseRepository = DatabaseRepository();

  static const messages = [
    'Introduce tu nombre, usuario y correo electrónico.',
    'Ingresa tu contraseña y confírmala.',
    'Ingresa tu codigo de acceso al área de tutor.',
  ];

  static const errorMessages = [
    'Completa los campos correctamente.',
    'Las contraseñas no coinciden o son muy cortas.',
    'Ingrese un codigo valido.',
  ];

  bool isNameValid = true;
  bool isUsernameValid = true;
  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isConfirmPasswordValid = true;
  bool isCodeValid = true;

  String nameErrorMessage = '';
  String usernameErrorMessage = '';
  String emailErrorMessage = '';
  String passwordErrorMessage = '';
  String confirmPasswordErrorMessage = '';
  String codeErrorMessage = '';

  @override
  void initState() {
    super.initState();
    _onIndexChanged();
  }

  void _onIndexChanged() {
    setState(() {
      text = messages[widget.pageIndex];
    });
    if (widget.pageIndex == 2) {
      Timer(const Duration(milliseconds: 1000), () {
        AudioManager.effects().play('sound/codigo.m4a');
      });
    }
  }

  Future<void> _registerTutor() async {
    setState(() {
      isLoading = true;
      widget.setLoading(true);
      isNameValid =
          Validator(widget.nameController.text).checkEmpty().isValid();
      isUsernameValid =
          Validator(widget.usernameController.text).checkEmpty().isValid();
      isEmailValid = Validator(widget.emailController.text)
          .checkEmpty()
          .checkEmail()
          .isValid();
      isPasswordValid = Validator(widget.passwordController.text)
          .checkEmpty()
          .checkLength(6)
          .isValid();
      isConfirmPasswordValid = widget.passwordController.text ==
          widget.confirmPasswordController.text;
      isCodeValid = Validator(widget.codeController.text)
          .checkEmpty()
          .checkLength(4)
          .isValid();

      nameErrorMessage = isNameValid
          ? ''
          : Validator(widget.nameController.text).checkEmpty().errorMessage();
      usernameErrorMessage = isUsernameValid
          ? ''
          : Validator(widget.usernameController.text)
              .checkEmpty()
              .errorMessage();
      emailErrorMessage = isEmailValid
          ? ''
          : Validator(widget.emailController.text)
              .checkEmpty()
              .checkEmail()
              .errorMessage();
      passwordErrorMessage = isPasswordValid
          ? ''
          : Validator(widget.passwordController.text)
              .checkEmpty()
              .checkLength(6)
              .errorMessage();
      confirmPasswordErrorMessage =
          isConfirmPasswordValid ? '' : 'Passwords do not match';
      codeErrorMessage = isCodeValid
          ? ''
          : Validator(widget.codeController.text)
              .checkEmpty()
              .checkLength(4)
              .errorMessage();
    });

    bool isValid = isNameValid &&
        isUsernameValid &&
        isEmailValid &&
        isPasswordValid &&
        isConfirmPasswordValid &&
        isCodeValid;

    if (!isValid) {
      setState(() {
        isLoading = false;
        widget.setLoading(false);
      });

      final errorMessage = !isNameValid || !isUsernameValid || !isEmailValid
          ? errorMessages[0]
          : !isPasswordValid || !isConfirmPasswordValid
              ? errorMessages[1]
              : errorMessages[2];

      final snackBar = SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Error de validación',
          message: errorMessage,
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

      return;
    }

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
      widget.setLoading(false);
    });

    final snackBar = SnackBar(
      content: AwesomeSnackbarContent(
        title: success ? 'Registrado con éxito' : 'Registro fallido',
        message: success
            ? 'Has sido registrado con éxito! Inicia sesión para continuar.'
            : 'Ha ocurrido un error al registrarte. Intenta de nuevo.',
        contentType: success ? ContentType.success : ContentType.failure,
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

    if (success) {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutorLoginScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: CustomTextWidget(
                      text: text,
                      type: TextType.Subtitle,
                      fontSize: 16,
                      color: ColorType.Primary,
                      shadow: false,
                    ),
                  ),
                  Expanded(
                    child: GalloComponent.dancing(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.pageIndex == 0) ...[
                      TextField(
                        controller: widget.nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          labelStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isNameValid ? Colors.black : Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isNameValid ? Colors.black : Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: widget.usernameController,
                        decoration: InputDecoration(
                          labelText: 'Usuario',
                          labelStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isUsernameValid
                                    ? Colors.black
                                    : Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isUsernameValid
                                    ? Colors.black
                                    : Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: widget.emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo Electrónico',
                          labelStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    isEmailValid ? Colors.black : Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    isEmailValid ? Colors.black : Colors.red),
                          ),
                        ),
                      ),
                    ] else if (widget.pageIndex == 1) ...[
                      TextField(
                        controller: widget.passwordController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isPasswordValid
                                    ? Colors.black
                                    : Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isPasswordValid
                                    ? Colors.black
                                    : Colors.red),
                          ),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: widget.confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Contraseña',
                          labelStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isConfirmPasswordValid
                                    ? Colors.black
                                    : Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isConfirmPasswordValid
                                    ? Colors.black
                                    : Colors.red),
                          ),
                        ),
                        obscureText: true,
                      ),
                    ] else if (widget.pageIndex == 2) ...[
                      TextField(
                        controller: widget.codeController,
                        maxLength: 4,
                        decoration: InputDecoration(
                          labelText: 'Codigo',
                          labelStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isCodeValid ? Colors.black : Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: isCodeValid ? Colors.black : Colors.red),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _registerTutor,
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
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
