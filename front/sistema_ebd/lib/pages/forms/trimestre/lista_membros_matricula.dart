import 'package:flutter/material.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/membros_repositories.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/models/membro.dart';
import 'package:sistema_ebd/models/usuarioLogado.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembrosMatricula extends ConsumerStatefulWidget {
  final String turma;
  final List<dynamic> membrosRemover;
  final List<dynamic> listaMembrosSelecionados;
  const MembrosMatricula({
    super.key,
    required this.turma,
    required this.membrosRemover,
    required this.listaMembrosSelecionados,
  });

  @override
  ConsumerState<MembrosMatricula> createState() => _MembrosMatriculaState();
}

class _MembrosMatriculaState extends ConsumerState<MembrosMatricula> {
  final ScrollController _controller = ScrollController();
  late UsuarioLogado usuarioLog;
  List<Membro> membros = [];
  final requisicaoMembros = MembrosRepositories();
  bool fetchMaisMembros = false;
  int numeroPage = 1;
  bool loadingPage = true;

  @override
  void initState() {
    super.initState();
    usuarioLog = ref.read(usuarioLogado);
    fetchMembros(numeroPage++).then((_) {
      setState(() {
        loadingPage = false;
      });
    });
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (membros.length < totalMembros) {
          if (!fetchMaisMembros) {
            setState(() {
              fetchMaisMembros = true;
            });
          }
          fetchMembros(numeroPage++);
        } else {
          setState(() {
            fetchMaisMembros = false;
          });
        }
      }
    });
  }

  Future<void> fetchMembros(int page) async {
    try {
      List<Membro> resposta = await requisicaoMembros.getMembros(
        numeroPage: page,
        token: usuarioLog.token,
      );
      if (resposta.isNotEmpty) {
        resposta.removeWhere((item) => widget.membrosRemover.contains(item.id));
        for (final item in resposta) {
          if (widget.listaMembrosSelecionados.contains(item.id)) {
            item.selectBox = true;
          }
        }
        setState(() {
          membros.addAll(resposta);
        });
      }
    } catch (e) {
      showError(e.toString());
    }
  }

  showError(String msg) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 2),
        content: Center(child: Text(msg)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final conteudo = Padding(
      padding: EdgeInsets.only(top: 30, left: 18, right: 18),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Selecione os alunos para a classe ${widget.turma}',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.copyWith(fontSize: 13),
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: membros.length + 1,
              itemBuilder: (context, index) {
                if (index < membros.length) {
                  Membro membro = membros[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(
                        top: 0,
                        bottom: 0,
                        right: 4,
                        left: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color:
                              membro.selectBox
                                  ? Color(0xFF008000)
                                  : Color.fromARGB(250, 231, 230, 237),
                          width: 1.6,
                        ),
                      ),
                      tileColor:
                          membro.selectBox ? Color(0xFFCBEFCB) : Colors.white,
                      title: Text(
                        membro.nome,
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium!.copyWith(
                          color:
                              membro.selectBox
                                  ? Color(0xFF008000)
                                  : Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Checkbox(
                        value: membro.selectBox,
                        activeColor: Color(0xFF008000),
                        onChanged: (value) {
                          setState(() {
                            membro.selectBox = value!;
                          });
                        },
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child:
                          fetchMaisMembros
                              ? CircularProgressIndicator()
                              : SizedBox(height: 25),
                    ),
                  );
                }
              },
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                List<String> listaIdMembros = [];
                for (Membro membro in membros) {
                  if (membro.selectBox) {
                    listaIdMembros.add(membro.id);
                  }
                }
                Navigator.pop(context, listaIdMembros);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 100),
                backgroundColor: Color(0xFF1565C0),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Matricular Alunos',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
    final msgVazio = Center(child: Text('Nenhum membro disponível'));
    return Material(
      child: Scaffold(
        appBar: CriarAppBar(context, widget.turma),
        body:
            loadingPage
                ? Center(child: CircularProgressIndicator())
                : membros.isEmpty
                ? msgVazio
                : conteudo,
      ),
    );
  }
}
