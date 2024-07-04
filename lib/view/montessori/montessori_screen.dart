import 'dart:ui';

import 'package:flutter/material.dart';

class MontessoriScreen extends StatelessWidget {
  const MontessoriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.white.withOpacity(0.5),
              child: const Center(
                child: Text(
                  "Método Montessori",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        centerTitle: true,
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //       Navigator.of(context).pop();
        //     },
        //     child: Container(
        //       margin: const EdgeInsets.symmetric(horizontal: 30),
        //       child: Image.asset(
        //         'assets/images/icons/exit.png',
        //         width: 32,
        //         height: 32,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/montessoribg2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 80, left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "La metodología Montessori es un enfoque educativo centrado en el niño, que fomenta el aprendizaje a través del juego y la exploración.",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text("Principios clave",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PrincipleCard(
                    icon: Icons.gamepad,
                    title: "Aprendizaje",
                    description:
                        "Los niños aprenden mejor cuando se divierten y experimentan directamente.",
                  ),
                  PrincipleCard(
                    icon: Icons.self_improvement,
                    title: "Independencia",
                    description:
                        "Fomentamos la autonomía y la auto-disciplina en los niños.",
                  ),
                  PrincipleCard(
                    icon: Icons.house,
                    title: "Ambiente preparado",
                    description:
                        "Un entorno organizado y atractivo es esencial para el aprendizaje.",
                  ),
                  PrincipleCard(
                    icon: Icons.person,
                    title: "Educación personalizada",
                    description:
                        "Cada niño aprende a su propio ritmo y según sus intereses.",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text("Beneficios",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BenefitItem(
                      icon: Icons.school,
                      text:
                          "Desarrollo de habilidades cognitivas, sociales y emocionales."),
                  BenefitItem(
                      icon: Icons.lightbulb,
                      text: "Fomento de la curiosidad y la creatividad."),
                  BenefitItem(
                      icon: Icons.self_improvement,
                      text: "Construcción de confianza y auto-estima."),
                ],
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text("Montessori en nuestra Aplicación:",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ExampleItem(
                    icon: Icons.format_list_numbered,
                    title: "Aprender Números",
                    description:
                        "Juegos interactivos para aprender a contar y reconocer números en francés con la ayuda del español.",
                  ),
                  ExampleItem(
                    icon: Icons.videogame_asset,
                    title: "Vocales Divertidas",
                    description:
                        "Actividades para aprender las vocales en francés, utilizando audio y juegos.",
                  ),
                  ExampleItem(
                    icon: Icons.family_restroom,
                    title: "Conoce la Familia",
                    description:
                        "Juegos que enseñan los nombres de los miembros de la familia en francés, fomentando la memoria y la asociación.",
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ExampleItem(
                    icon: Icons.record_voice_over,
                    title: "Audio Guía",
                    description:
                        "Todos los juegos incluyen audio en francés y español para facilitar el aprendizaje.",
                  ),
                  ExampleItem(
                    icon: Icons.person_pin,
                    title: "Personaje Guía",
                    description:
                        "Un personaje amigable guía a los niños a través de todas las actividades, haciendo el aprendizaje más divertido.",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrincipleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const PrincipleCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 250,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.lightGreen),
              const SizedBox(height: 10),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class BenefitItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const BenefitItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.lightGreen),
              const SizedBox(height: 10),
              Text(text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class ExampleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const ExampleItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.lightGreen),
              const SizedBox(height: 10),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
