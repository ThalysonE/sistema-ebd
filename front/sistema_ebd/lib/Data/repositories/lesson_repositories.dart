import 'dart:convert';

import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/models/lesson.dart';

int totalLessons = 0;

class LessonRepository {
  final IHttpClient client = HttpClient();

  /// Busca aulas. Se [trimesterRoomId] for informado, filtra por turma.
  Future<List<Lesson>> getLessons({
    required int page,
    required String token,
    String? trimesterRoomId,
    int perPage = 50,
  }) async {
    List<Lesson> lessons = [];

    final queryParams = <String, String>{
      'page': page.toString(),
      'perPage': perPage.toString(),
    };

    if (trimesterRoomId != null && trimesterRoomId.isNotEmpty) {
      queryParams['trimesterRoomId'] = trimesterRoomId;
    }

    final url = Uri.parse(
      '$apiUrl/lesson',
    ).replace(queryParameters: queryParams);

    final resposta = await client.get(url: url, token: token);

    if (resposta.statusCode != 200) {
      if (resposta.statusCode == 500) {
        throw Exception('Erro interno no servidor');
      }
      throw Exception('Erro ao buscar aulas: ${resposta.statusCode}');
    }

    final body = jsonDecode(resposta.body);
    if (page == 1) {
      totalLessons = body['meta']['totalCount'];
    }

    body['lessons'].map((item) {
      lessons.add(Lesson.fromMap(item));
    }).toList();

    return lessons;
  }

  /// Cria uma nova aula. Retorna o statusCode da resposta.
  Future<int> postLesson({
    required String token,
    required String trimesterRoomId,
    required String preLessonId,
    required String title,
    required List<Map<String, dynamic>> studentsAttendance,
    required int visitors,
    required int bibles,
    required int magazines,
    required double offers,
  }) async {
    final url = Uri.parse('$apiUrl/lesson');
    final body = {
      'trimesterRoomId': trimesterRoomId,
      'preLessonId': preLessonId,
      'title': title,
      'studentsAttendance': studentsAttendance,
      'visitors': visitors,
      'bibles': bibles,
      'magazines': magazines,
      'offers': offers,
    };

    final resposta = await client.post(url: url, body: body, token: token);
    return resposta.statusCode;
  }
}
