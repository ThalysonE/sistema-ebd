import 'package:sistema_ebd/Data/http/http_client.dart';

abstract class ILoginRepository {
  Future<dynamic> authLogin({required String login, required String senha});
}

class LoginRepository implements ILoginRepository{
  final IHttpClient client;

  LoginRepository({required this.client});

  @override
  Future<dynamic> authLogin({required String login, required String senha}) async {
    var dados = {'username':login.toLowerCase(),'password':senha};
    try{
      final resposta = await client.post(
      url: 'http://192.168.0.75:3333/auth/login',
      body: dados,
    );
      return resposta;
    } catch(e){
      print('Erro ao processar a resposta: ${e}');
      return null;
    }
  }
}
