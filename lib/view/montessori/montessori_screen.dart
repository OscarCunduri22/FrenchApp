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
                  "Metodología Montessori",
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/montessoribg.jpg"), // Reemplaza con tu imagen de fondo
            fit: BoxFit.cover,
          ),
        ),
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "La metodología Montessori es un enfoque educativo centrado en el niño, que fomenta el aprendizaje a través del juego y la exploración.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text("Principios Clave:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Row(
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
              SizedBox(height: 20),
              Text("Beneficios:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BenefitItem(
                      icon: Icons.person,
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
              SizedBox(height: 20),
              Text("Montessori en nuestra Aplicación:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ExampleItem(
                    icon: Icons.edit,
                    title: "Juego de trazo de números y letras",
                    description:
                        "Diseñado para desarrollar la motricidad fina y el reconocimiento de símbolos.",
                  ),
                  ExampleItem(
                    icon: Icons.local_activity,
                    title: "Actividades prácticas",
                    description:
                        "Juegos que simulan actividades del día a día para fomentar la independencia.",
                  ),
                ],
              ),
              SizedBox(height: 20),
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
      height: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.lightGreen),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(description, textAlign: TextAlign.center),
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
      width: 150,
      height: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.lightGreen),
              const SizedBox(height: 10),
              Text(text, textAlign: TextAlign.center),
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
      width: 350,
      height: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.lightGreen),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(description, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
