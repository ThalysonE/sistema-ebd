import 'dart:async';
import 'dart:convert';
import 'package:sistema_ebd/Data/repositories/login_repositories.dart';
import 'package:sistema_ebd/models/usuarioLogado.dart';
import'package:flutter_riverpod/flutter_riverpod.dart';


final usuarioLogado = StateNotifierProvider<AuthUsuario, UsuarioLogado>((ref){
  final loginRepository = LoginRepository();

  return AuthUsuario(repository: loginRepository);
});

class AuthUsuario extends StateNotifier<UsuarioLogado>{
  final LoginRepository repository;
  AuthUsuario({required this.repository}): super(UsuarioLogado('', ''));

  Future login(String usuario, String senha) async{
    try{
      dynamic resposta = await repository.authLogin(login: usuario, senha: senha);
      if(resposta.statusCode == 200){
        final body = jsonDecode(resposta.body);
        state = UsuarioLogado(usuario, body['access_token']);
      }
      await Future.delayed(Duration(milliseconds: 500));
      return resposta.statusCode; 
    }catch(e){
      print('Erro no provider Login: ${e.toString()}');
      return null;
    }
  }

}