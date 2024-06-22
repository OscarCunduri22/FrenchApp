import 'package:flutter/material.dart';
import 'package:frenc_app/widgets/auth/botton_buttons.dart';
import 'package:frenc_app/widgets/custom_theme_text.dart';
import 'package:frenc_app/widgets/step_progress.dart';
import '../../widgets/auth/page_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _controller = PageController(initialPage: 0);
  double _currentPageValue = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPageValue = _controller.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/global/clouds-creditsbg.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextWidget(
                    text: "Registrarse",
                    type: TextType.Title,
                    fontSize: 44,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w200,
                  ),
                ],
              ),
              StepProgress(currenstStep: _currentPageValue, steps: 3),
              Expanded(
                child: PageView(
                  controller: _controller,
                  children: [
                    PageScreen(
                      title: "Usuario",
                      subtitle: "Email",
                      pageIndex: 0,
                      nameController: nameController,
                      usernameController: usernameController,
                      emailController: emailController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      codeController: codeController,
                    ),
                    PageScreen(
                      title: "Contrase",
                      subtitle: "Validacion de contraseña",
                      pageIndex: 1,
                      nameController: nameController,
                      usernameController: usernameController,
                      emailController: emailController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      codeController: codeController,
                    ),
                    PageScreen(
                      title: "Codigo",
                      subtitle: "Enter",
                      pageIndex: 2,
                      nameController: nameController,
                      usernameController: usernameController,
                      emailController: emailController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      codeController: codeController,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: BottomButtons(pageController: _controller),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
