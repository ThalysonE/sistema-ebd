import 'dart:convert';

import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/models/matricula.dart';

int totalMatriculas = 0;

abstract class IMatriculaRepository {
  Future<List<Matricula>> getMatriculas({
    required int numeroPage,
    required String token,
    required String trimesterRoomId,
    String? nome,
  });
}

class MatriculaRepository implements IMatriculaRepository {
  final IHttpClient client = HttpClient();

  @override
  Future<List<Matricula>> getMatriculas({
    required int numeroPage,
    required String token,
    required String trimesterRoomId,
    String? nome,
  }) async {
    List<Matricula> matriculas = [];

    final queryParams = <String, String>{
      'page': numeroPage.toString(),
      'perPage': '15',
      'trimesterRoomId': trimesterRoomId,
    };

    if (nome != null && nome.isNotEmpty) {
      queryParams['name'] = nome;
    }

    final url = Uri.parse(
      '$apiUrl/registration',
    ).replace(queryParameters: queryParams);

    final resposta = await client.get(url: url, token: token);
    final statusCode = resposta.statusCode;
    print('Status Matrículas: $statusCode');

    if (statusCode != 200) {
      if (statusCode == 500) {
        throw Exception('Erro interno no servidor, tente novamente mais tarde');
      } else if (statusCode == 400) {
        throw Exception('Erro na requisição');
      }
    }

    final body = jsonDecode(resposta.body);
    if (numeroPage == 1) {
      totalMatriculas = body['meta']['totalCount'];
    }

    body['registrations'].map((item) {
      final Matricula matricula = Matricula.fromMap(item);
      matriculas.add(matricula);
    }).toList();

    return matriculas;
  }
}
