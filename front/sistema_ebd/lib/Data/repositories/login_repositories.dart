import 'dart:convert';

import 'package:sistema_ebd/Data/http/http_client.dart';

abstract class ILoginRepository {
  Future<String?> authLogin({required login, required senha});
}

class LoginRepository implements ILoginRepository {
  final IHttpClient client;

  LoginRepository({required this.client});

  @override
  Future<String?> authLogin({required login, required senha}) async {
    var dados = {'username':login,'password':senha};
    var code = jsonEncode(dados);
    print(code);
    final resposta = await client.post(
      url: 'http://localhost:3333/auth/login',
      body: jsonEncode(dados),
    );
      final body = jsonDecode(resposta.body);
    
    if(resposta.statusCode == 200){
      print('login feito\nChave:${body['access_token']}');
      
      return body.access_token; 
    }else{
      print('Algum erro deu\n ${body}');
    }
  }
}
