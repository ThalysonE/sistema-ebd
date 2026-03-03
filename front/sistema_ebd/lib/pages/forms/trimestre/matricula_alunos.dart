import 'package:flutter/material.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/trimestre_repositories.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/models/trimestre/turma_trimestre.dart';
import 'package:sistema_ebd/models/usuarioLogado.dart';
import 'package:sistema_ebd/pages/forms/trimestre/lista_membros_matricula.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatriculaAlunos extends ConsumerStatefulWidget {
  final String idTrimestre;
  const MatriculaAlunos({super.key, required this.idTrimestre});

  @override
  ConsumerState<MatriculaAlunos> createState() => _MatriculaAlunosState();
}

class _MatriculaAlunosState extends ConsumerState<MatriculaAlunos> {
  final ScrollController _controller = ScrollController();
  late UsuarioLogado usuarioLog;

  bool isLoading = true;
  bool fetchMaisTurmas = false;
  bool matriculandoAlunos = false;

  int numeroPage = 1;
  List<TurmaTrimestre> turmastrimestre = [];

  final trimestreTurmaRequisicao = TrimestreRepository();

  @override
  void initState() {
    super.initState();
    usuarioLog = ref.read(usuarioLogado);
    getTurmasTrimestre(numeroPage++).then((_) {
      setState(() {
        isLoading = false;
      });
    });
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (turmastrimestre.length < totalTurmasTrimestre) {
          if (!fetchMaisTurmas) {
            setState(() {
              fetchMaisTurmas = true;
            });
          }
          getTurmasTrimestre(numeroPage++);
        } else {
          setState(() {
            fetchMaisTurmas = false;
          });
        }
      }
    });
  }

  List<Map<String, dynamic>> listaDeAlunosMatricular = [];

  showError(String msg, int cor) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: cor == 1 ? Colors.red[400] : Colors.orange[400],
        duration: Duration(seconds: 2),
        content: Center(child: Text(msg)),
      ),
    );
  }

  Future<void> matricularAlunos() async {
    setState(() {
      matriculandoAlunos = true;
    });
    try {
      for (final item in listaDeAlunosMatricular) {
        if ((item['idsAlunosSelecionados'] as List).isNotEmpty) {
          await trimestreTurmaRequisicao.matricularAlunos(
            token: usuarioLog.token,
            idTurmaTrimestre: item['idTrimesterRoom'],
            alunosId: item['idsAlunosSelecionados'],
          );
        }
      }
      setState(() {
        matriculandoAlunos = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            content: Center(child: Text('Alunos matriculados com sucesso!')),
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      setState(() {
        matriculandoAlunos = false;
      });
      showError(e.toString(), 1);
    }
  }

  Future<void> getTurmasTrimestre(int page) async {
    try {
      final resposta = await trimestreTurmaRequisicao.getTurmasTrimestre(
        numeroPage: page,
        token: usuarioLog.token,
        idTrimestre: widget.idTrimestre,
      );
      setState(() {
        turmastrimestre.addAll(resposta);
        _inicializarListaAlunos();
      });
    } catch (e) {
      showError(e.toString(), 1);
    }
  }

  void _inicializarListaAlunos() {
    while (listaDeAlunosMatricular.length < turmastrimestre.length) {
      final item = turmastrimestre[listaDeAlunosMatricular.length];
      listaDeAlunosMatricular.add({
        "idTrimesterRoom": item.id,
        "idsAlunosSelecionados": [],
      });
    }
  }

  direcionaPaginaMembros(int index, TurmaTrimestre item) async {
    List<dynamic> idsMembrosEmOutraTurma = [];
    List<dynamic> idsMembrosSelecionados =
        listaDeAlunosMatricular[index]["idsAlunosSelecionados"];
    for (Map<String, dynamic> x in listaDeAlunosMatricular) {
      if (!x['idsAlunosSelecionados'].isEmpty &&
          x != listaDeAlunosMatricular[index]) {
        idsMembrosEmOutraTurma.addAll(x['idsAlunosSelecionados']);
      }
    }
    final retornoIdsMembros = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MembrosMatricula(
              turma: item.nome,
              listaMembrosSelecionados: idsMembrosSelecionados,
              membrosRemover: idsMembrosEmOutraTurma,
            ),
      ),
    );
    if (retornoIdsMembros != null) {
      if (retornoIdsMembros.length > idsMembrosSelecionados.length) {
        for (final id in retornoIdsMembros) {
          if (!idsMembrosSelecionados.contains(id)) {
            idsMembrosSelecionados.add(id);
            turmastrimestre[index].registros += 1;
          }
        }
      } else if (retornoIdsMembros.length < idsMembrosSelecionados.length) {
        for (final id in List.from(idsMembrosSelecionados)) {
          if (!retornoIdsMembros.contains(id)) {
            idsMembrosSelecionados.remove(id);
            turmastrimestre[index].registros -= 1;
          }
        }
      }
      setState(() {
        turmastrimestre[index].registros;
      });
      listaDeAlunosMatricular[index]['idsAlunosSelecionados'] =
          idsMembrosSelecionados;
    }
  }

  get conteudo {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 18, right: 18),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Selecione a turma para matricular alunos',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.copyWith(fontSize: 13),
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: turmastrimestre.length + 1,
              controller: _controller,
              itemBuilder: (context, index) {
                if (index < turmastrimestre.length) {
                  TurmaTrimestre item = turmastrimestre[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: Color.fromARGB(218, 231, 230, 237),
                        ),
                        bottom: BorderSide(
                          width: 1,
                          color: Color.fromARGB(218, 231, 230, 237),
                        ),
                        right: BorderSide(
                          width: 1,
                          color: Color.fromARGB(218, 231, 230, 237),
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        direcionaPaginaMembros(index, item);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border(
                            left: BorderSide(width: 10, color: Colors.teal),
                          ),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.nome,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium!.copyWith(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                item.registros.toString(),
                                style: Theme.of(
                                  context,
                                ).textTheme.labelMedium!.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      item.registros == 0
                                          ? Colors.red
                                          : Colors.green,
                                ),
                              ),
                            ],
                          ),
                          tileColor: Colors.white,
                          trailing: Icon(Icons.chevron_right, size: 32),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child:
                          fetchMaisTurmas
                              ? CircularProgressIndicator()
                              : SizedBox(height: 25),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: CriarAppBar(context, 'Matricular Alunos'),
        body:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : turmastrimestre.isEmpty
                ? Center(child: Text('Nenhuma turma cadastrada no trimestre'))
                : conteudo,
        bottomNavigationBar: Container(
          color: Color(0xFFfaf9fe),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: ElevatedButton(
              onPressed:
                  matriculandoAlunos
                      ? null
                      : () {
                        if (listaDeAlunosMatricular.isNotEmpty) {
                          bool algumAlunoSelecionado = false;
                          for (final x in listaDeAlunosMatricular) {
                            if ((x['idsAlunosSelecionados'] as List)
                                .isNotEmpty) {
                              algumAlunoSelecionado = true;
                              break;
                            }
                          }
                          if (algumAlunoSelecionado) {
                            matricularAlunos();
                          } else {
                            showError('Nenhum aluno selecionado', 2);
                          }
                        } else {
                          showError('Nenhum aluno selecionado', 2);
                        }
                      },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 100),
                backgroundColor: Color(0xFF1565C0),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child:
                  matriculandoAlunos
                      ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Color(0xFF1565C0),
                        ),
                      )
                      : Text(
                        'Finalizar',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
