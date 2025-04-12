import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/turmas_repositories.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/models/turma.dart';

class Turmas extends ConsumerStatefulWidget {
  const Turmas({super.key});

  @override
  ConsumerState<Turmas> createState() => _TurmasState();
}

class _TurmasState extends ConsumerState<Turmas> {
  ScrollController _controllerScroll = ScrollController();
  List<Turma>? turmas = [];
  int numeroPaginaTurmas = 1;
  var usuarioLogadoUser;
  var conteudo;
  bool isLoading = true;
  bool novasTurmas = false;
  final requisicaoTurmas = TurmasRepositories();

  final formKey = GlobalKey<FormState>();
  TextEditingController _nomeController = TextEditingController();
  Future<void> fetchTurmas(int numeroPag) async {
    turmas = await requisicaoTurmas.getTurmas(
      numeroPag,
      usuarioLogadoUser.token,
    );
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
              ],
            ),
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                icon: Icon(Icons.add_circle_outline, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
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
        padding: EdgeInsets.only(top: 50, right: 15, left: 15),
        child: ListView.builder(
          controller: _controllerScroll,
          itemCount: turmas!.length + 1,
          itemBuilder: (context, index) {
            if (index < turmas!.length) {
              Turma item = turmas![index];
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  onTap: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Color.fromARGB(218, 231, 230, 237),
                      width: 1,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Container(height: double.maxFinite,width: 10, color: Colors.,),
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
              onPressed: cadastro,
              icon: Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
        body: conteudo,
      ),
    );
  }
}
