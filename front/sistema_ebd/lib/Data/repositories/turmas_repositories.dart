import 'dart:convert';

import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/models/turma.dart';

abstract class IturmasRepository {
  Future<List<Turma>?> getTurmas(int numeroPagina, String token);
  Future<int?> postTurmas({
    required String name,
    required String token,
    int? minAge = null,
    int? maxAge = null,
  });
}

class TurmasRepositories extends IturmasRepository {
  final IHttpClient client;
  TurmasRepositories(this.client);

  Future<List<Turma>?> getTurmas(int numeroPagina, String token) async {
    final url = Uri.parse(
      apiUrl + '/room',
    ).replace(queryParameters: {'page': numeroPagina.toString()});
    List<Turma> turmas = [];
    try {
      final resposta = await client.get(url: url, token: token);
      print('Reposta Turmas: ${resposta.statusCode}');
      if (resposta.statusCode == 200) {
        final body = jsonDecode(resposta.body);
        body['rooms'].map((turmaMap) {
          final turma = Turma.fromMap(turmaMap);
          turmas.add(turma);
        }).toList();
        print(turmas[0].name);
        return turmas;
      }
    } catch (e) {
      print('Erro na requisição de turmas');
    }
    return null;
  }

  Future<int?> postTurmas({
    required String name,
    required String token,
    int? minAge = null,
    int? maxAge = null,
  }) async {
    final url = apiUrl + 'room';
    final body = {'name': name, 'minAge': minAge, 'maxAge': maxAge};
    try {
      final resposta = await client.post(url: url, body: body, token: token);
      if (resposta.statusCode == 200) {
        print('Cadastro realizado com sucesso!');
      } else {
        print('Erro no cadastro');
      }
      return resposta.statusCode;
    } catch (e) {
      print('Erro na requisição: ${e.toString()}');
      return null;
    }
  }
}
