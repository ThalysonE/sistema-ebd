import 'package:flutter/material.dart';

class TelaEmAndamento extends StatelessWidget {
  const TelaEmAndamento({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: Text('Em desenvolvimento...', style: TextStyle(color: Colors.black),),
      ),
    );
  }
}