import 'package:flutter/material.dart';
import 'package:sistema_ebd/pages/telaInicial.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Telainicial()
      ),
    );
  }
}