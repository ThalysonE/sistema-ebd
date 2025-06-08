import 'dart:convert';

import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/models/usuario.dart';

abstract class IUsuariosRepository {
  Future<dynamic> getUsuariosRole({required int numeroPage, required String token, required cargo});
}

class UsuariosRepository implements IUsuariosRepository{
  final IHttpClient client = HttpClient();

  @override
  Future<dynamic> getUsuariosRole({required int numeroPage, required String token, required cargo}) async {
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
    print('Estado UUU: ${statusCode}');
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
}
