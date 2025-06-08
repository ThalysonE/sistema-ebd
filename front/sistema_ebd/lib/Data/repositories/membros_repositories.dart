import 'dart:convert';
import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';

import 'package:sistema_ebd/models/membro.dart';

abstract class IMembrosRepository{
  
  Future<List<Membro>?> getMembros({required int numeroPage, required String token});
}

class MembrosRepositories implements IMembrosRepository{
  
  final IHttpClient client = HttpClient();


  @override
  Future<List<Membro>?> getMembros({required int numeroPage, required String token})async{
    List<Membro> membros= [];
    final url = Uri.parse('$apiUrl/member').replace(
      queryParameters: {
        "page": numeroPage.toString(),
        "perPage": "15"
      }
    );
    try{
      final resposta = await client.get(url: url, token: token);
      final body = jsonDecode(resposta.body);
      if(resposta.statusCode == 200){
        if(numeroPage == 1){
          totalMembros = body['meta']['totalCount'];
        }
        body['members'].map((item){
          final Membro membro = Membro.fromMap(item);
          membros.add(membro);
        }).toList();
        return membros;
     }
    } catch(e){
      print('Erro ao fazer a requisição: ${e.toString()}');
    }
    return null;
  }
  Future<List<Membro>?> searchMembro({required String nome, required String token}) async{
    List<Membro> resultMembros = [];
    final url = Uri.parse('$apiUrl/member').replace(
      queryParameters: {
        "name": nome,
      }
    );
    try{
      final resposta = await client.get(url: url, token: token);
      if(resposta.statusCode == 200){
        final body = jsonDecode(resposta.body);
        body['members'].map((item){
          final membro = Membro.fromMap(item);
          resultMembros.add(membro);
        }).toList();
        return resultMembros;
      }
    }
    catch(e){
      print('Erro ao pesquisar membro: ${e.toString()}');
    }
    return null;
  }

  Future<int?> CadastrarMembro({required String nome, required String dataNasc, required String sexo, required String token}) async{
    final url = Uri.parse('$apiUrl/member');
    final body = {
      "name": nome,
      "birthDate": dataNasc,
      "sex": sexo == 'Masculino'? "MALE": "FEMALE",
    };
    try{
      final resposta = await client.post(url: url, body: body, token: token);
      if(resposta.statusCode == 201){
        print('Cadastro realizado com sucesso');
      }
      else{
        print('Erro ao realizar o cadastro');
      }
      return resposta.statusCode;
      
    }catch(e){
      print("Um erro ocorreu na requisição: ${e.toString()}");
      return null;
    }
  }
  Future<Membro> fetchMembroPorId({required String idMembro, required String token}) async {
    final url = Uri.parse('$apiUrl/user').replace(
      queryParameters: {
        "id": idMembro
      }
    );
    final resposta = await client.get(url: url, token: token);
    final statusCode = resposta.statusCode;
    if(statusCode != 200){
      if(statusCode == 500){
        throw Exception('Erro interno no servidor, tente novamente mais tarde');
      }
    }
    final body = jsonDecode(resposta.body);
    Membro professorMembro = Membro.fromMap(body['member']);
    return professorMembro;
  }
}