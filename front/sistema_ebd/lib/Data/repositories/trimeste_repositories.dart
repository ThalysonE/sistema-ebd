import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';

abstract class ITrimestreRepository {
  Future<int?> postTrimestre(
    String nome,
    String ano,
    String quarter,
    String dataInicio,
    String dataFim,
    String tokenUser
  );
}

class TrimesteRepositories implements ITrimestreRepository {
  IHttpClient client = HttpClient();
  @override
  Future<int?> postTrimestre(
    String nome,
    String ano,
    String quarter,
    String dataInicio,
    String dataFim,
    String tokenUser,
  ) async {
    final url = Uri.parse('$apiUrl/trimester');
    final body = {
      "title": nome,
      "year": ano,
      "quarter": quarter,
      "startDate": dataInicio,
      "endDate": dataFim,
    };
    try {
      final resposta = await client.post(
        url: url,
        body: body,
        token: tokenUser,
      );
      if (resposta.statusCode == 201) {
        print('Cadastro de trimestre realizado com sucesso!');
      }
      return resposta.statusCode;
    } catch (e) {
      print('Erro na requisicao de cadastro de Trimestre: ${e.toString()}');
    }
    return null;
  }
}
