import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/pages/forms/membro_form.dart';
import 'package:sistema_ebd/pages/tela_membros.dart';
import 'package:sistema_ebd/pages/tela_principal.dart';
import 'package:sistema_ebd/pages/forms/usuario_form.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistema_ebd/utils/rotas.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
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
        scaffoldBackgroundColor: Color(0xFFfaf9fe)
      ),
      routes: {
        AppRotas.login: (context) => UsuarioForm(),
        AppRotas.inicio: (context)=> TelaPrincipal(),
        AppRotas.membros:(context)=> TelaMembros(),
        AppRotas.cadastro_membros:(context)=> MembroForm(),
        // AppRotas.turmas:(context)=> Turmas()
      },
      home: Scaffold(
        backgroundColor: Colors.white,
        body: UsuarioForm()
      ),  
    );
  }
}
