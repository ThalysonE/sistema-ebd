import 'dart:ffi';

import 'package:flutter/material.dart';


class UsuarioForm extends StatefulWidget {
  const UsuarioForm({super.key});

  @override
  State<UsuarioForm> createState() => _UsuarioFormState();
}

class _UsuarioFormState extends State<UsuarioForm> {
  final keyform = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Login',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold
            ),
          ),
          Text(
            'Bem vindo de volta!',
            style: TextStyle(
              color: Color(0xFF4B5768),
              fontSize: 18,
              fontWeight: FontWeight.w400
            ),
          ),
          SizedBox(height: 30,),
          Form(
            key: keyform,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Usuario',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text(
                      'Erica',
                      style: TextStyle(
                        color: Color(0xFFAFADBE),
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    border: OutlineInputBorder(
                      
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 10,),
                Text(
                  'Senha',
                  style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      ),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text(
                      '. . . . . ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFAFADBE),
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never
                  ),
                  keyboardType: TextInputType.visiblePassword,
                )
              ],
            )
          ),
        ],
      ),
    );
  }
}