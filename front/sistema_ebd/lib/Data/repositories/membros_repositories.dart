

import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:sistema_ebd/models/membro.dart';

abstract class IMembrosRepository{
  
  Future<List<Membro>?> getMembros({required int numeroPage, required String token});
}

class MembrosRepositories implements IMembrosRepository{
  
  
  Future<List<Membro>?> getMembros({required int numeroPage, required String token})async{
    final dio = Dio();
    final List<Membro> membros= [];
    final body = {
      'page': numeroPage
    };
    try{
      final resposta = await dio.get(
        'http://192.168.0.75:3333/member',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json', 
            'Authorization': 'Bearer ${token}',
          }
        )
      );
      final data = resposta.data;
      data['members'].map((item){
        final Membro membro = Membro.fromMap(item);
        membros.add(membro);
      }).toList();
      return membros;
    } catch(e){
      print('Erro ao fazer a requisição:${e.toString()}');
      return null;
    }
  }
  

}