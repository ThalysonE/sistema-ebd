import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/turmas_repositories.dart';
import 'package:sistema_ebd/models/turma.dart';

class Turmas extends ConsumerStatefulWidget {
  const Turmas({super.key});

  @override
  ConsumerState<Turmas> createState() => _TurmasState();
}

class _TurmasState extends ConsumerState<Turmas> {
  ScrollController _controllerScroll = ScrollController();
  List<Turma>? turmas = [];
  var usuarioLogadoUser;
  var conteudo;
  bool isLoading = true;
  bool novosMembros = false;
  final requisicaoTurmas = TurmasRepositories(HttpClient());
  Future<void> fetchTurmas(int numeroPag) async {
    turmas = await requisicaoTurmas.getTurmas(
      numeroPag,
      usuarioLogadoUser.token,
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    usuarioLogadoUser = ref.read(usuarioLogado);
    _controllerScroll.addListener((){
      if(_controllerScroll.position.maxScrollExtent == _controllerScroll.offset){
        
      }
    });
    fetchTurmas(1);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      conteudo = Center(child: CircularProgressIndicator.adaptive());
    } else if (turmas == null) {
      conteudo = Center(
        child: Text('Um erro ocorreu, tente novamente mais tarde'),
      );
    } else if (turmas!.isEmpty) {
      conteudo = Center(child: Text('Nenhuma turma cadastrada.'));
    } else {
      conteudo = Padding(
        padding: EdgeInsets.only(top: 50, right: 15, left: 15),
        child: ListView.builder(
          controller: _controllerScroll,
          itemCount: turmas!.length + 1,
          itemBuilder: (context, index) {
            Turma item = turmas![index];

            if (index < turmas!.length) {
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  onTap: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Color.fromARGB(218, 231, 230, 237),
                      width: 1.2,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Alunos: 0',
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium!.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(185, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                  tileColor: Colors.white,
                  trailing: Icon(Icons.chevron_right, size: 32),
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child:
                      novosMembros
                          ? CircularProgressIndicator()
                          : SizedBox(height: 25),
                ),
              );
            }
          },
        ),
      );
    }
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: true,
          title: Text(
            'Turmas',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(242, 255, 255, 255),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
        body: conteudo,
      ),
    );
  }
}
