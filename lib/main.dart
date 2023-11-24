import 'package:flutter/material.dart';
import 'package:flutter_procesamiento_del_lenguaje/src/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'NLP',
      home: Home(),
    );
  }
}
