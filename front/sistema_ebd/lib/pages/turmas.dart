import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/Data/http/http_client.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/turmas_repositories.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/models/turma.dart';

class Turmas extends ConsumerStatefulWidget {
  const Turmas({super.key});

  @override
  ConsumerState<Turmas> createState() => _TurmasState();
}

class _TurmasState extends ConsumerState<Turmas> {
  List<Turma>? turmas = [];
  var usuarioLogadoUser;
  var conteudo;
  final requisicaoTurmas = TurmasRepositories(HttpClient());
  Future<void> fetchTurmas(int numeroPag) async {
    turmas = await requisicaoTurmas.getTurmas(numeroPag, usuarioLogadoUser.token);
  }

  @override
  void initState() {
    super.initState();
    usuarioLogadoUser = ref.read(usuarioLogado);
    fetchTurmas(1);
  }

  @override
  Widget build(BuildContext context) {
    if (turmas == null) {
      conteudo = Center(
        child: Text('Um erro ocorreu, tente novamente mais tarde'),
      );
    } else {
      conteudo = Padding(
        padding: EdgeInsets.only(top: 50, right: 15, left: 15),
        child: ListView.builder(
          itemCount: turmas!.length,
          itemBuilder: (context, index) {
            Turma item = turmas![index];
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Color.fromARGB(250, 231, 230, 237),
                  width: 1.6,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Alunos: 0',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              tileColor: Colors.white,

              trailing: Icon(Icons.chevron_right),
            );
          },
        ),
      );
    }
    return Material(
      child: Scaffold(appBar: CriarAppBar(context, 'Turmas'), body: conteudo),
    );
  }
}
