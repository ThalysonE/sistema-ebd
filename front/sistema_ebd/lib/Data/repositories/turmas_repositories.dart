import 'dart:convert';

import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/models/turma.dart';

abstract class IturmasRepository {
  Future<List<Turma>?> getTurmas(int numeroPagina, String token);
  Future<int?> postTurmas({
    required String name,
    required String token,
    int? minAge,
    int? maxAge,
  });
}

class TurmasRepositories extends IturmasRepository {
  final IHttpClient client = HttpClient();
  @override
  Future<List<Turma>?> getTurmas(int numeroPagina, String token) async {
    final url = Uri.parse('$apiUrl/room').replace(
      queryParameters: {'page': numeroPagina.toString(), 'perPage': '15'},
    );
    List<Turma> turmas = [];
    try {
      final resposta = await client.get(url: url, token: token);
      print('Reposta Turmas: ${resposta.statusCode}');
      if (resposta.statusCode == 200) {
        final body = jsonDecode(resposta.body);
        if (numeroPagina == 1) {
          totalTurmas = body['meta']['totalCount'];
        }
        body['rooms'].map((turmaMap) {
          final turma = Turma.fromMap(turmaMap);
          turmas.add(turma);
        }).toList();
        return turmas;
        
      }
    } catch (e) {
      print('Erro na requisição de turmas: ${e.toString()}');
    }
    return null;
  }

  @override
  Future<int?> postTurmas({
    required String name,
    required String token,
    int? minAge,
    int? maxAge,
  }) async {
    final url = Uri.parse('$apiUrl/room');
    final body = {"name": name, "minAge": minAge, "maxAge": maxAge};
    print(body);
    try {
      final resposta = await client.post(url: url, body: body, token: token);
      if (resposta.statusCode == 201) {
        print('Cadastro realizado com sucesso!');
      } else {
        print('Erro no cadastro: ${resposta.statusCode}');
      }
      return resposta.statusCode;
    } catch (e) {
      print('Erro na requisição: ${e.toString()}');
      return null;
    }
  }
}
