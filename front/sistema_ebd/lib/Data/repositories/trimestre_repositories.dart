import 'dart:convert';

import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/models/trimestre/trismestre.dart';
import 'package:sistema_ebd/models/trimestre/turma_trimestre.dart';

abstract class ITrimestreRepository {
  Future<List<Trimestre>> getTrimestre({required int numeroPage, required String token, String numTrimestre, String ano});
  Future<String> postTrimestre({required String token, required String titulo, required int ano, required int numTrimestre, required String dataInicio, required String dataFim});
}

class TrimestreRepository implements ITrimestreRepository{
  final IHttpClient client = HttpClient();

  @override
  Future<List<Trimestre>> getTrimestre({required int numeroPage, required String token, String numTrimestre = "", String ano = ""}) async {
    List<Trimestre> trimestres= [];
    final url;
    if(numTrimestre.isEmpty && ano.isEmpty){
      url = Uri.parse('$apiUrl/trimester').replace(
        queryParameters: {
          "page": numeroPage.toString(),
          "perPage": "15"
        }
      );
    }else{
      url = Uri.parse('$apiUrl/trimester').replace(
        queryParameters: {
          "page": numeroPage.toString(),
          "perPage": "15",
          "quarter": numTrimestre.toString(), 
          "year": ano.toString()
        }
      );
    }
    final resposta = await client.get(url: url, token: token);
    final statusCode = resposta.statusCode;
    if(statusCode !=200){
      if(statusCode == 500){
        throw Exception('Erro interno no servidor, tente novamente mais tarde');
      }
    }
    final body = jsonDecode(resposta.body);
    if(numeroPage == 1){
      totalTrimestres = body['meta']['totalCount'];
    }
    body['trimesters'].map((item){
      final Trimestre trimestre = Trimestre.fromMap(item);
      trimestres.add(trimestre);
    }).toList();
    return trimestres;
  }
  Future<String> postTrimestre({required String token, required String titulo, required int ano, required int numTrimestre, required String dataInicio, required String dataFim}) async{
    final url = Uri.parse('$apiUrl/trimester');
    final body = {
      "title": titulo,
      "year": ano,
      "quarter": numTrimestre,
      "startDate": dataInicio,
      "endDate": dataFim
    };
    final resposta = await client.post(url: url, body: body, token: token); 
    final status = resposta.statusCode;
    print('Status: ${status}');
    if(status != 201){
      if(status == 500){
        throw Exception('Erro no servidor, não foi possivel realizar o cadastro do trimestre');
      }else if(status == 400){
        throw Exception('Já existe um trimestre cadastrado nesse período');
      }
    }
    final bodyResposta = jsonDecode(resposta.body);
    final idTrimestre = bodyResposta['trimester']['_id']['value'];
    return idTrimestre;
  }
  Future<void> alocarTurmasTrimestre({required String token, required String idTrimestre, required List<String> turmasId}) async{
    final url = Uri.parse('$apiUrl/trimester-room');
    final body = {
      "trimesterId": idTrimestre,
      "roomsIds": turmasId
    };

    final resposta = await client.post(url: url, body: body, token: token); 
    final status = resposta.statusCode;
    if(status != 201){
      if(status == 500){
        throw Exception('Erro no servidor, não foi possivel realizar o cadastro do trimestre');
      }else if(status == 400){
        throw Exception('Algum erro na requisição');
      }
    }
    print('Codigo: ${status} deuuu certo');
  }
  Future<void> alocarProfessoresTrimestre({required String token, required String idTurmaTrimestre, required List<dynamic> professoresId}) async{
    final url = Uri.parse('$apiUrl/trimester-room/allocate/teacher');
    final body = {
      "teachersIds": professoresId,
      "trimesterRoomId": idTurmaTrimestre 
    };

    final resposta = await client.post(url: url, body: body, token: token); 
    final status = resposta.statusCode;
    print('Alocu professor: ${status}');
    if(status != 201){
      if(status == 500){
        throw Exception('Erro no servidor, não foi possivel realizar o cadastro do trimestre');
      }else if(status == 400){
        throw Exception('Algum erro na requisição');
      }else if(status == 404){
        throw Exception('Professor não encontrado no banco de dados');
      }
    }

  }
  Future<List<TurmaTrimestre>> getTurmasTrimestre({required int numeroPage, required String token, required String idTrimestre}) async {
    List<TurmaTrimestre> turmasTrimestre= [];
    final url = Uri.parse('$apiUrl/trimester-room').replace(
      queryParameters: {
        "page": numeroPage.toString(),
        "perPage": "15",
        "trimesterId": idTrimestre
      }
    );
    
    final resposta = await client.get(url: url, token: token);
    final statusCode = resposta.statusCode;
    print('Status Turmas Trimestre : ${statusCode}');
    print(resposta.body);
    if(statusCode !=200){
      if(statusCode == 500){
        throw Exception('Erro interno no servidor, tente novamente mais tarde');
      }
    }
    final body = jsonDecode(resposta.body);
    if(numeroPage == 1){
      totalTurmasTrimestre = body['meta']['totalCount'];
    }
    body['trimestersRooms'].map((item){
      final TurmaTrimestre turmaTrimestre = TurmaTrimestre.fromMap(item);
      turmasTrimestre.add(turmaTrimestre);
    }).toList();
    return turmasTrimestre;
  }
}
