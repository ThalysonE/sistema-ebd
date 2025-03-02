import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/repositories/login_repositories.dart';


class UsuarioForm extends StatefulWidget {
  const UsuarioForm({super.key});

  @override
  State<UsuarioForm> createState() => _UsuarioFormState();
}

class _UsuarioFormState extends State<UsuarioForm> {
  final keyform = GlobalKey<FormState>();
  final LoginRepository loginRepository = LoginRepository(client: HttpClient());
  bool ativadoLembrar = false;
  bool esconderSenha = true;
  String _login ='';
  String _senha ='';
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Login',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 35,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 8,),
            Text(
              'Bem vindo de volta!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Color(0xFF4B5768),
                fontSize: 18,
                fontWeight: FontWeight.w400
              )
            ),
            SizedBox(height: 40,),
            Form(
              key: keyform,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Usuário',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Color(0xFFD0D5DD)
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Theme.of(context).buttonTheme.colorScheme!.primary
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Colors.red
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Theme.of(context).buttonTheme.colorScheme!.primary
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      label: Text(
                        'Erica',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Color(0xFFAFADBE),
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Por favor, insira um nome de usuário.';
                      }
                      return null;
                    },
                    onSaved: (value){
                      _login = value!;
                    },
                  ),
                  SizedBox(height: 35,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Senha',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        'Esqueceu a senha?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF538CC1)
                        ),
                      ),
                      
                    ],
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Color(0xFFD0D5DD)
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Theme.of(context).buttonTheme.colorScheme!.primary
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Colors.red
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Theme.of(context).buttonTheme.colorScheme!.primary
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            esconderSenha = !esconderSenha;
                          });
                        }, 
                        icon: Icon(esconderSenha?Icons.remove_red_eye_outlined:Icons.remove_red_eye)
                      ),
                      
                      label: Text(
                        '. . . . . ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Color(0xFFAFADBE),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never
                    ),
                    keyboardType:TextInputType.visiblePassword,
                    obscureText: esconderSenha,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Por favor, insira uma senha válida.';
                      }else if(value.length < 6){
                        return 'Insira uma senha maior que 6 digitos';
                      } 
                      return null;
                    },
                    onSaved: (value){
                      _senha = value!;
                    },
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Switch(
                        value: ativadoLembrar,
                        activeColor: Colors.white,
                        activeTrackColor: Color(0xFF1565C0),
                        inactiveThumbColor: Color(0xFF1565C0),
                        onChanged: (value){
                          setState(() {
                            ativadoLembrar = value;
                          });
                        },
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Lembrar de mim',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: Color(0xFF6A6C71),
                          fontWeight: FontWeight.w800
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 42,),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 13, horizontal: 130),
                        backgroundColor: Color(0xFF1565C0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        )
                      ),
                      onPressed: (){
                        if(keyform.currentState!.validate()){
                          keyform.currentState!.save();
                          print('login: ${_login}\nsenha: ${_senha}');
                          loginRepository.authLogin(login: _login, senha: _senha);
                        }
                      }, 
                      child: Text(
                        'Login',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15
                        ),
                    
                      )
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}