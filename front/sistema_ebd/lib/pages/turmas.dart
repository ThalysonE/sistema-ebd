import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/turmas_repositories.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/models/turma.dart';
import 'package:sistema_ebd/pages/forms/trimestre/turmas_professor.dart';

class Turmas extends ConsumerStatefulWidget {
  final bool temCadastro;
  Turmas({super.key, required this.temCadastro});

  @override
  ConsumerState<Turmas> createState() => _TurmasState();
}

class _TurmasState extends ConsumerState<Turmas> {
  ScrollController _controllerScroll = ScrollController();
  List<Turma>? turmas = [];
  List<Turma> listaTurmasSelecionadas = [];
  int numeroPaginaTurmas = 1;
  var usuarioLogadoUser;
  var conteudo;
  bool isLoading = true;
  bool novasTurmas = false;
  final requisicaoTurmas = TurmasRepositories();

  final formKey = GlobalKey<FormState>();

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _idadeMinController = TextEditingController();
  TextEditingController _idadeMaxController = TextEditingController();
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

  mostrarMsg(int tipoMsg) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          tipoMsg == 0
              ? 'Erro ao cadastrar a turma, tente novamente'
              : 'Turma cadastrada com sucesso!',
          style: TextStyle(color: tipoMsg == 0 ? Colors.red : Colors.green),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void postTurma() async {
    if (formKey.currentState!.validate()) {
      final resposta = await requisicaoTurmas.postTurmas(
        name: _nomeController.text,
        token: usuarioLogadoUser.token,
        minAge:
            _idadeMinController.text.isEmpty
                ? null
                : int.parse(_idadeMinController.text),
        maxAge:
            _idadeMaxController.text.isEmpty
                ? null
                : int.parse(_idadeMaxController.text),
      );
      if (resposta == 201) {
        numeroPaginaTurmas = 1;
        turmas = [];
        fetchTurmas(numeroPaginaTurmas++);
        mostrarMsg(1);
      } else {
        mostrarMsg(0);
      }
      Navigator.pop(context);
    }
  }

  //colocar em outra pagina
  cadastro() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Cadastro Turma',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Text(
                  'Nome da turma: ',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(181, 0, 0, 0),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Color(0xFFD0D5DD),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color:
                            Theme.of(context).buttonTheme.colorScheme!.primary,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color:
                            Theme.of(context).buttonTheme.colorScheme!.primary,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    label: Text(
                      'Nome da Turma',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O nome deve ter mais de 3 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                Text(
                  'Idade Mínima ',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(181, 0, 0, 0),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _idadeMinController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Color(0xFFD0D5DD),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color:
                            Theme.of(context).buttonTheme.colorScheme!.primary,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color:
                            Theme.of(context).buttonTheme.colorScheme!.primary,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    label: Text(
                      'Idade minima',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Idade Inválida';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                Text(
                  'Idade Mínima ',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(181, 0, 0, 0),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _idadeMaxController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Color(0xFFD0D5DD),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color:
                            Theme.of(context).buttonTheme.colorScheme!.primary,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color:
                            Theme.of(context).buttonTheme.colorScheme!.primary,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    label: Text(
                      'Idade Máxima',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Idade Inválida';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                icon: Icon(Icons.add_circle_outline, color: Colors.white),
                onPressed: () {
                  postTurma();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 90),
                  backgroundColor: Color(0xFF1565C0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                label: Text(
                  'Cadastrar',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
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
                      child: Text(
                        'Continuar',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed:
                          temTurmaSelecionada
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => AlocacaoProfessores(
                                          turmasSelecionadas:
                                              listaTurmasSelecionadas,
                                        ),
                                  ),
                                );
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
                    ),
                  ),
                )
                : SizedBox.shrink(),
      ),
    );
  }
}
