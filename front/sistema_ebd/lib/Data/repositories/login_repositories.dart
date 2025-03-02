import 'dart:convert';

import 'package:sistema_ebd/Data/http/http_client.dart';

abstract class ILoginRepository {
  Future<int?> authLogin({required String login, required String senha});
}

class LoginRepository implements ILoginRepository {
  final IHttpClient client;

  LoginRepository({required this.client});

  @override
  Future<int?> authLogin({required String login, required String senha}) async {
    var dados = {'username':login.toLowerCase(),'password':senha};
    try{
      final resposta = await client.post(
      url: 'http://localhost:3333/auth/login',
      body: dados,
    );
      final body = jsonDecode(resposta.body);
      if(resposta.statusCode == 200){
        print('login feito\nChave:${body['access_token']}');
        //implementar algo para guardar o token do usuario
      } 
      return resposta.statusCode;
    } catch(e){
      print('Erro ao processar a resposta: ${e}');
      return null;
    }
  }
}
