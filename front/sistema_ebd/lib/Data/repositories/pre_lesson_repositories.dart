import 'dart:convert';

import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/models/pre_lesson.dart';

abstract class IPreLessonRepository {
  Future<List<PreLesson>?> getPreLessons({
    required int page,
    required String token,
    required String trimesterId,
    int perPage,
    bool? inProgress,
  });
  Future<int?> postPreLesson({
    required String token,
    required String trimesterId,
    required String date,
    required int numberLesson,
  });
}

int totalPreLessons = 0;

class PreLessonRepository implements IPreLessonRepository {
  final IHttpClient client = HttpClient();

  @override
  Future<List<PreLesson>?> getPreLessons({
    required int page,
    required String token,
    required String trimesterId,
    int perPage = 15,
    bool? inProgress,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'perPage': perPage.toString(),
      'trimesterId': trimesterId,
    };
    if (inProgress != null) {
      queryParams['inProgress'] = inProgress.toString();
    }

    final url = Uri.parse(
      '$apiUrl/pre-lesson',
    ).replace(queryParameters: queryParams);

    List<PreLesson> preLessons = [];
    try {
      final resposta = await client.get(url: url, token: token);
      if (resposta.statusCode == 200) {
        final body = jsonDecode(resposta.body);
        if (page == 1) {
          totalPreLessons = body['meta']['totalCount'];
        }
        body['preLessons'].map((item) {
          final preLesson = PreLesson.fromMap(item);
          preLessons.add(preLesson);
        }).toList();
        return preLessons;
      }
    } catch (e) {
      print('Erro na requisição de pre-lessons: ${e.toString()}');
    }
    return null;
  }

  @override
  Future<int?> postPreLesson({
    required String token,
    required String trimesterId,
    required String date,
    required int numberLesson,
  }) async {
    final url = Uri.parse('$apiUrl/pre-lesson');
    final body = {
      "trimesterId": trimesterId,
      "date": date,
      "numberLesson": numberLesson,
    };
    try {
      final resposta = await client.post(url: url, body: body, token: token);
      if (resposta.statusCode == 201) {
        print('Pre-lesson cadastrada com sucesso!');
      } else {
        print('Erro no cadastro de pre-lesson: ${resposta.statusCode}');
      }
      return resposta.statusCode;
    } catch (e) {
      print('Erro na requisição de pre-lesson: ${e.toString()}');
      return null;
    }
  }
}
