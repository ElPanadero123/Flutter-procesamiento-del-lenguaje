import 'package:flutter/material.dart';
import 'package:natural_languaje_processing_mobile/models/user.dart';

class QuestionsScreen extends StatelessWidget {
  final UserNLP user;

  const QuestionsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          title: RichText(
            textAlign: TextAlign.end,
            text: const TextSpan(
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Preguntas que puedes realizar',
                ),
              ],
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 158, 0, 68), // Rojo oscuro
                  Colors.white, // Blanco
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 158, 0, 68), // Rojo oscuro
              Colors.white, // Blanco
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: QuestionsList(),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionsList extends StatelessWidget {
  final List<String> questions = [
    '¿Cuáles son los horarios de atención de las oficinas de trámites y archivos?',
    '¿Quiénes desarrollaron este modelo de procesamiento de lenguaje natural?',
    '¿Cuáles son las becas disponibles para estudiantes regulares de la universidad?',
    '¿Cuándo se fundó la universidad y cuál es su historia?',
    '¿Quién es el encargado de trámites, archivos y habilitaciones?',
    '¿Cuántas sedes tiene la universidad y dónde están ubicadas?',
    '¿Cuáles son los horarios de atención de las cajas y dirección de carrera?',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            questions[index],
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
