


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/membros_repositories.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/models/membro.dart';
import 'package:sistema_ebd/models/usuario.dart';

final listaMembros = StateNotifierProvider<MembroProvider,List<Membro>>((ref){
  final usuarioAuth = ref.read(usuarioLogado);
  return MembroProvider(usuario: usuarioAuth);
});

class MembroProvider extends StateNotifier<List<Membro>>{
  UsuarioLogado usuario;
  MembroProvider({required this.usuario}):super([]);

  Future loadMembros({required int page}) async{
    final repository = MembrosRepositories(client: HttpClient());
    try{
      List<Membro>? membros = await repository.getMembros(numeroPage: page, token: usuario.token);
      if(membros != null){
        state = [...state, ...membros]..sort((a,b)=>a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
      }
    }catch(e){
      print('Erro no provider: ${e.toString()}');
    } 
  }
  Future searchMembro({required String nome}) async{
    final repository = MembrosRepositories(client: HttpClient());
    try{
      final membros = await repository.searchMembro(nome: nome, token: usuario.token);
      return membros;
    }catch(e){
      print('Erro no provider: ${e.toString()}');
      return null;
    }
  }
  Future<int?> cadastrarMembro({required nome, required dataNasc, required sexo}) async{
    final repository = MembrosRepositories(client: HttpClient());
    try{
      final codigo = await repository.CadastrarMembro(nome: nome, dataNasc: dataNasc, sexo: sexo, token: usuario.token);
      if(codigo == 201){
        final novoMembro = Membro(nome: nome, dataDeNascimento: dataNasc, sexo: sexo == 'Masculino'? 'MALE': 'FEMALE');
        state = [...state, novoMembro]..sort((a,b)=>a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
        totalMembros++;
      }
      return codigo;
    }catch(e){
      print('Erro no provider: ${e.toString()}');
      return null;
    }

  }
}