import 'package:flutter/material.dart';

class TelaEmAndamento extends StatelessWidget {
  const TelaEmAndamento({super.key});

  @override
  Widget build(BuildContext context) {
    return  Material(
      child: Scaffold(
        backgroundColor:Color(0xFFfaf9fe) ,
        body: Center(
            child: Text(
              'Em desenvolvimento...',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500
              ),
              
            ),
        ),
      ),
    );
  }
}
