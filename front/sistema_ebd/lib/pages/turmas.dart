import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/trimestre_repositories.dart';
import 'package:sistema_ebd/Data/repositories/turmas_repositories.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/Widgets/dialog_cadastro_turma.dart';
import 'package:sistema_ebd/models/turma.dart';
import 'package:sistema_ebd/pages/forms/trimestre/turmas_professor.dart';

class Turmas extends ConsumerStatefulWidget {
  final bool temCadastro;
  final String idTrimestre; 
  const Turmas({super.key, required this.temCadastro, this.idTrimestre = ""});

  @override
  ConsumerState<Turmas> createState() => _TurmasState();
}

class _TurmasState extends ConsumerState<Turmas> {
  final ScrollController _controllerScroll = ScrollController();
  List<Turma>? turmas = [];
  List<Turma> listaTurmasSelecionadas = [];
  int numeroPaginaTurmas = 1;
  var usuarioLogadoUser;
  var conteudo;
  bool isLoading = true;
  bool novasTurmas = false;
  
  final requisicaoTurmas = TurmasRepositories();

  //variaveis trimestre
  final requisicaoTrimestre = TrimestreRepository();
  bool loadingCadastrandoTurmas = false;
  showError(String msg){
    return ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 2),
        content: Center(
          child: Text(msg)
        )
      )
    );
  }
  Future<void> cadastroTurmasTrimestre(List<String> idsTurmas) async{
    setState(() {
      loadingCadastrandoTurmas = true;
    });
    try{
      await requisicaoTrimestre.alocarTurmasTrimestre(token: usuarioLogadoUser.token, idTrimestre: widget.idTrimestre, turmasId: idsTurmas);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => AlocacaoProfessores(
                idTrimestre: widget.idTrimestre,
              ),
        ),
      );
    }catch(e){
      showError(e.toString());
    }
    setState(() {
      loadingCadastrandoTurmas = false;
    });
  }
  Future<void> fetchTurmas(int numeroPag) async {
    final fetchTurmas = await requisicaoTurmas.getTurmas(
      numeroPag,
      usuarioLogadoUser.token,
    );
    if (fetchTurmas == null) {
      turmas = null;
    } else if (turmas == null) {
      turmas = fetchTurmas;
    } else {
      turmas!.addAll(fetchTurmas);
    }
    print('teste turmas: ${turmas}');
    setState(() {
      if (isLoading) {
        isLoading = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    usuarioLogadoUser = ref.read(usuarioLogado);
    fetchTurmas(numeroPaginaTurmas++);
    _controllerScroll.addListener(() {
      if (_controllerScroll.position.maxScrollExtent ==
          _controllerScroll.offset) {
        if (turmas!.length < totalTurmas) {
          if (!novasTurmas) {
            setState(() {
              novasTurmas = true;
            });
          }
          fetchTurmas(numeroPaginaTurmas++);
        } else {
          setState(() {
            novasTurmas = false;
          });
        }
      }
    });
  }

  recarregarTurmas() {
    numeroPaginaTurmas = 1;
    turmas = [];
    fetchTurmas(numeroPaginaTurmas++);
    //pq nao é necessario esse setState?
    setState(() {});
  }

  mostrarMsg(int tipoMsg) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            tipoMsg == 0
                ? 'Erro ao cadastrar a turma, tente novamente'
                : 'Turma cadastrada com sucesso!',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: tipoMsg == 0 ? Colors.red : Colors.green,
      ),
    );
  }

  //colocar em outra pagina
  cadastro() {
    showDialog(
      context: context,
      builder: (context) {
        return CadastroDialog(
          usuarioToken: usuarioLogadoUser.token,
          recarregarTurmas: recarregarTurmas,
          mostrarMsg: mostrarMsg,
        );
      },
    );
  }

  bool get temTurmaSelecionada {
    if (turmas == null || turmas!.isEmpty) {
      return false;
    }
    for (Turma turma in turmas!) {
      if (turma.selectBox!) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    _controllerScroll.dispose();
    super.dispose();
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
        padding: EdgeInsets.only(right: 15, left: 15),
        child: ListView.builder(
          controller: _controllerScroll,
          itemCount: turmas!.length + 1,
          itemBuilder: (context, index) {
            if (index < turmas!.length) {
              Turma item = turmas![index];
              if (index == 0) {
                return Column(
                  children: [
                    SizedBox(height: 30),
                    !widget.temCadastro
                        ? Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Selecione as turmas que irão compor o trimestre',
                                textAlign: TextAlign.center,
                                style: Theme.of(
                                  context,
                                ).textTheme.labelMedium!.copyWith(fontSize: 13),
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        )
                        : SizedBox.shrink(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border(
                          top: BorderSide(
                            width: !item.selectBox! ? 1 : 1.5,
                            color:
                                !item.selectBox!
                                    ? Color.fromARGB(218, 231, 230, 237)
                                    : Colors.green,
                          ),
                          bottom: BorderSide(
                            width: !item.selectBox! ? 1 : 1.5,
                            color:
                                !item.selectBox!
                                    ? Color.fromARGB(218, 231, 230, 237)
                                    : Colors.green,
                          ),
                          right: BorderSide(
                            width: !item.selectBox! ? 1 : 1.5,
                            color:
                                !item.selectBox!
                                    ? Color.fromARGB(218, 231, 230, 237)
                                    : Colors.green,
                          ),
                        ),
                      ),
                      margin: EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (!widget.temCadastro) {
                            setState(() {
                              item.selectBox = !item.selectBox!;
                            });
                          }
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
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
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
                                widget.temCadastro
                                    ? Text(
                                      'Alunos: 0',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium!.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: const Color.fromARGB(
                                          185,
                                          0,
                                          0,
                                          0,
                                        ),
                                      ),
                                    )
                                    : SizedBox.shrink(),
                              ],
                            ),
                            tileColor: Colors.white,
                            trailing:
                                widget.temCadastro
                                    ? Icon(Icons.chevron_right, size: 32)
                                    : Checkbox(
                                      value: item.selectBox,
                                      activeColor: Color(0xFF008000),
                                      onChanged: (value) {
                                        setState(() {
                                          item.selectBox = value;
                                        });
                                      },
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      top: BorderSide(
                        width: !item.selectBox! ? 1 : 1.5,
                        color:
                            !item.selectBox!
                                ? Color.fromARGB(218, 231, 230, 237)
                                : Colors.green,
                      ),
                      bottom: BorderSide(
                        width: !item.selectBox! ? 1 : 1.5,
                        color:
                            !item.selectBox!
                                ? Color.fromARGB(218, 231, 230, 237)
                                : Colors.green,
                      ),
                      right: BorderSide(
                        width: !item.selectBox! ? 1 : 1.5,
                        color:
                            !item.selectBox!
                                ? Color.fromARGB(218, 231, 230, 237)
                                : Colors.green,
                      ),
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      if (!widget.temCadastro) {
                        setState(() {
                          item.selectBox = !item.selectBox!;
                        });
                      }
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
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
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
                            widget.temCadastro
                                ? Text(
                                  'Alunos: 0',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium!.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: const Color.fromARGB(185, 0, 0, 0),
                                  ),
                                )
                                : SizedBox.shrink(),
                          ],
                        ),
                        tileColor: Colors.white,
                        trailing:
                            widget.temCadastro
                                ? Icon(Icons.chevron_right, size: 32)
                                : Checkbox(
                                  value: item.selectBox,
                                  activeColor: Color(0xFF008000),
                                  onChanged: (value) {
                                    setState(() {
                                      item.selectBox = value;
                                    });
                                  },
                                ),
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child:
                      novasTurmas
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
        appBar:
            widget.temCadastro
                ? AppBar(
                  backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor,
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
                      onPressed: cadastro,
                      icon: Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                )
                : CriarAppBar(context, 'Turmas'),
        body: conteudo,
        bottomNavigationBar:
            !widget.temCadastro
                ? Container(
                  color: Color(0xFFfaf9fe),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    child: ElevatedButton(
                      onPressed: loadingCadastrandoTurmas
                        ? null
                        :temTurmaSelecionada
                              ? () {
                                for (Turma turma in turmas!) {
                                  if (turma.selectBox! &&
                                      !listaTurmasSelecionadas.contains(
                                        turma,
                                      )) {
                                    listaTurmasSelecionadas.add(turma);
                                  } else if (!turma.selectBox! &&
                                      listaTurmasSelecionadas.contains(turma)) {
                                    listaTurmasSelecionadas.remove(turma);
                                  }
                                }
                                if(listaTurmasSelecionadas.isNotEmpty){
                                  List<String> idsTurmas = [];
                                  for(final turma in listaTurmasSelecionadas){
                                    idsTurmas.add(turma.id);
                                  }
                                  cadastroTurmasTrimestre(idsTurmas);
                                }
                                
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 100,
                        ),
                        backgroundColor: Color(0xFF1565C0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: loadingCadastrandoTurmas
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Color(0xFF1565C0)
                          ),
                        )
                      : Text(
                        'Continuar',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
                : SizedBox.shrink(),
      ),
    );
  }
}
