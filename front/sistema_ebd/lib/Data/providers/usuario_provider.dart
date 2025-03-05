import 'dart:convert';

import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/repositories/login_repositories.dart';
import 'package:sistema_ebd/models/usuario.dart';
import'package:flutter_riverpod/flutter_riverpod.dart';


final usuarioLogado = StateNotifierProvider<AuthUsuario, UsuarioLogado>((ref){
  final loginRepository = LoginRepository(client: HttpClient());

  return AuthUsuario(repository: loginRepository);
});

class AuthUsuario extends StateNotifier<UsuarioLogado>{
  final LoginRepository repository;
  AuthUsuario({required this.repository}): super(UsuarioLogado('', ''));

  late String erro;
  bool isLoading = false;
  Future login(String usuario, String senha) async{
    isLoading = true;
    try{
      dynamic resposta = await repository.authLogin(login: usuario, senha: senha);
      if(resposta.statusCode == 200){
        final body = jsonDecode(resposta.body);
        state = UsuarioLogado(usuario, body['access_token']);
      }
      print(resposta.statusCode);
      return resposta.statusCode; 
    }catch(e){
      erro = e.toString();
    }
    isLoading = false;
    return null;
  }

}