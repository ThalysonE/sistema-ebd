


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/membros_repositories.dart';
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
    final repository = MembrosRepositories();
    try{
      final membros = await repository.getMembros(numeroPage: page, token: usuario.token);
      state.addAll(membros!.toList());
      print(state);
    }catch(e){
      print('Erro no provider.');
    } 
  }
}