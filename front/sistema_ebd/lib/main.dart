import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/pages/telaInicial.dart';
import 'package:sistema_ebd/pages/usuario_form.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistema_ebd/utils/rotas.dart';

void main(List<String> args) {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //bool logovisivel = true;
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Timer(const Duration(seconds: 5), () {
    //     setState(() {
    //       logovisivel = false;
    //     });
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(primary: Color(0xFF034279)),
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 13, 95, 167),
        ),
      ),
      routes: {AppRotas.login: (context) => UsuarioForm()},
      home: Scaffold(body:UsuarioForm()),
    );
  }
}
