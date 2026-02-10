import 'dart:convert';

import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/repositories/membros_repositories.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/models/membro.dart';
import 'package:sistema_ebd/models/usuario.dart';

abstract class IUsuariosRepository {
  Future<dynamic> fetchUsuariosRole({required int numeroPage, required String token, required cargo});
}

class UsuariosRepository implements IUsuariosRepository{
  final IHttpClient client = HttpClient();
  final MembrosRepositories membroRequisicao = MembrosRepositories();
  @override
  Future<dynamic> fetchUsuariosRole({required int numeroPage, required String token, required cargo}) async {
    List<Usuario> usuarios= [];
    final url = Uri.parse('$apiUrl/user').replace(
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
  Future<List<Membro>> fetchUsuariosParaMembro({required int numeroPage, required String token, required cargo}) async {


    final url = Uri.parse('$apiUrl/user').replace(
      queryParameters: {
        "page": numeroPage.toString(),
        "perPage": "15",
        "role": cargo
      }
    );

    final resposta = await client.get(url: url, token: token);
    final statusCode = resposta.statusCode;
    print(statusCode);
    if(statusCode !=200){
      if(statusCode == 500){
        throw Exception('Erro interno no servidor, tente novamente mais tarde');
      }
    }
    final body = jsonDecode(resposta.body);
    if(numeroPage == 1){
      totalUsuarios = body['meta']['totalCount'];
    }
    final futures = body['users'].map<Future<Membro>>((item) async{
      final Usuario usuario = Usuario.fromMap(item);
      if(usuario.isMember == true){
        final Membro usuarioParaMembro = await membroRequisicao.fetchMembroPorId(idMembro: usuario.memberId, token: token);
        usuarioParaMembro.idUsuario = usuario.id;
        return usuarioParaMembro;
      }
    }).toList();
    List<Membro> membro = await Future.wait(futures);
    print(membro);
    return membro;
  }
}
