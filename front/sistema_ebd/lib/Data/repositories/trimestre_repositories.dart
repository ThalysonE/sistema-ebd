import 'dart:convert';

import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/models/usuario.dart';

abstract class ITrimestreRepository {
  Future<dynamic> getTrimestre({required int numeroPage, required String token, required cargo});
  void postTrimestre({required String token, required String titulo, required int ano, required int numTrimestre, required String dataInicio, required String dataFim});
}

class TrimestreRepository implements ITrimestreRepository{
  final IHttpClient client = HttpClient();

  @override
  Future<dynamic> getTrimestre({required int numeroPage, required String token, required cargo}) async {
    List<Usuario> usuarios= [];
    final url = Uri.parse('$apiUrl/trimester').replace(
      queryParameters: {
        "page": numeroPage.toString(),
        "perPage": "15",
        "role": cargo
      }
    );
    final resposta = await client.get(url: url, token: token);
    final statusCode = resposta.statusCode;
    if(statusCode !=200){
      if(statusCode == 500){
        throw Exception('Erro interno no servidor, tente novamente mais tarde');
      }
    }
    final body = jsonDecode(resposta.body);
    if(numeroPage == 1){
      totalUsuarios = body['meta']['totalCount'];
    }
    body['users'].map((item){
      final Usuario usuario = Usuario.fromMap(item);
      usuarios.add(usuario);
    }).toList();
    return usuarios;
  }
  void postTrimestre({required String token, required String titulo, required int ano, required int numTrimestre, required String dataInicio, required String dataFim}) async{
    final url = Uri.parse('$apiUrl/trimester');
    final body = {
      "title": titulo,
      "year": ano.toString(),
      "quarter": numTrimestre.toString(),
      "startDate": dataInicio,
      "endDate": dataFim
    };

    final resposta = await client.post(url: url, body: body, token: token); 
    final status = resposta.statusCode;
    if(status != 201){
      if(status == 500){
        throw Exception('Erro no servidor, não foi possivel realizar o cadastro do trimestre');
      }else if(status == 400){
        throw Exception('Já foi criado um trimestre nesse período');
      }
    }
    //retorna o id do trimestre aqui
  }
}
