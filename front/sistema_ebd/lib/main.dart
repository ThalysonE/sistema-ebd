import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sistema_ebd/pages/telaInicial.dart';
import 'package:sistema_ebd/pages/usuario_form.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool logovisivel = true;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), (){
      setState(() {
        logovisivel = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: logovisivel? Telainicial(): UsuarioForm()
      ),
    );
  }
}