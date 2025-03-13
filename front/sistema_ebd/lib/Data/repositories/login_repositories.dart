import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';

abstract class ILoginRepository {
  Future<dynamic> authLogin({required String login, required String senha});
}

class LoginRepository implements ILoginRepository{
  final IHttpClient client;

  LoginRepository({required this.client});

  @override
  Future<dynamic> authLogin({required String login, required String senha}) async {
    var dados = {'username':login.toLowerCase(),'password':senha};
    final url = Uri.parse(apiUrl + '/auth/login');
    try{
      final resposta = await client.post(
      url: url,
      body: dados,
    );
      return resposta;
    } catch(e){
      print('Erro ao processar a resposta: ${e}');
      return null;
    }
  }
}
