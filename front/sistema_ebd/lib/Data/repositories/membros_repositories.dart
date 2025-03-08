

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';

import 'package:sistema_ebd/models/membro.dart';

abstract class IMembrosRepository{
  
  Future<List<Membro>?> getMembros({required int numeroPage, required String token});
}

class MembrosRepositories implements IMembrosRepository{
  
  final IHttpClient client;
  MembrosRepositories({required this.client});

  Future<List<Membro>?> getMembros({required int numeroPage, required String token})async{
    List<Membro> membros= [];
    final url = Uri.parse('http://192.168.0.75:3333/member').replace(
      queryParameters: {
        "page": numeroPage.toString(),
        "perPage": "20"
      }
    );
    try{
      final resposta = await client.get(url: url, token: token);
      final body = jsonDecode(resposta.body);
      if(resposta.statusCode == 200){
        if(numeroPage == 1){
          totalMembros = body['meta']['totalCount'];
          print(totalMembros);
        }
        body['members'].map((item){
          final Membro membro = Membro.fromMap(item);
          membros.add(membro);
        }).toList();
        return membros;
     }
    } catch(e){
      print('Erro ao fazer a requisição:${e.toString()}');
    }
    return null;
  }
  Future<List<Membro>?> searchMembro({required String nome, required String token}) async{
    List<Membro> resultMembros = [];
    final url = Uri.parse('http://192.168.0.75:3333/member').replace(
      queryParameters: {
        "name": nome,
      }
    );
    try{
      final resposta = await client.get(url: url, token: token);
      if(resposta.statusCode == 200){
        final body = jsonDecode(resposta.body);
        print(body);
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

  

}