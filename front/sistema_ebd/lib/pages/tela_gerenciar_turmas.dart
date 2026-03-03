import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/turmas_repositories.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/Widgets/dialog_cadastro_turma.dart';
import 'package:sistema_ebd/models/turma.dart';
import 'package:sistema_ebd/models/usuarioLogado.dart';
import 'dart:async';

class TelaGerenciarTurmas extends ConsumerStatefulWidget {
  const TelaGerenciarTurmas({super.key});

  @override
  ConsumerState<TelaGerenciarTurmas> createState() =>
      _TelaGerenciarTurmasState();
}

class _TelaGerenciarTurmasState extends ConsumerState<TelaGerenciarTurmas> {
  final ScrollController _controller = ScrollController();
  Timer? _debounce;
  bool isLoading = true;
  bool novasTurmas = false;
  bool pesquisando = false;
  List<Turma> resultadoPesquisa = [];

  late UsuarioLogado userLog;
  int numeroPage = 1;
  TurmasRepositories turmasRequisicao = TurmasRepositories();
  List<Turma> turmas = [];

  showError(String msg) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 2),
        content: Center(child: Text(msg)),
      ),
    );
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

  Future<void> fetchTurmas(int page) async {
    try {
      final resposta = await turmasRequisicao.getTurmas(page, userLog.token);
      if (resposta != null) {
        turmas.addAll(resposta);
      }
      setState(() {});
    } catch (e) {
      showError(e.toString());
    }
  }

  Future<void> _recarregarTurmas() async {
    setState(() {
      turmas.clear();
      numeroPage = 1;
      isLoading = true;
    });
    await fetchTurmas(numeroPage++);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    userLog = ref.read(usuarioLogado);
    fetchTurmas(numeroPage++).then((_) {
      setState(() => isLoading = false);
    });
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (turmas.length < totalTurmas) {
          if (!novasTurmas) {
            setState(() => novasTurmas = true);
          }
          fetchTurmas(numeroPage++);
        } else {
          setState(() => novasTurmas = false);
        }
      }
    });
  }

  void searchTurma(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 700), () {
      if (query.isEmpty) {
        setState(() => pesquisando = false);
        return;
      }
      setState(() {
        pesquisando = true;
        resultadoPesquisa =
            turmas
                .where(
                  (t) => t.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      });
    });
  }

  void _abrirCadastroTurma() {
    showDialog(
      context: context,
      builder: (context) {
        return CadastroDialog(
          usuarioToken: userLog.token,
          recarregarTurmas: _recarregarTurmas,
          mostrarMsg: mostrarMsg,
        );
      },
    );
  }

  Widget _buildTurmaItem(Turma item) {
    String faixaEtaria = '';
    if (item.minAge != null && item.maxAge != null) {
      faixaEtaria = '${item.minAge} - ${item.maxAge} anos';
    } else if (item.minAge != null) {
      faixaEtaria = 'A partir de ${item.minAge} anos';
    } else if (item.maxAge != null) {
      faixaEtaria = 'Até ${item.maxAge} anos';
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(218, 231, 230, 237), width: 1),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 10),
        leading: CircleAvatar(
          backgroundColor: Colors.teal.withOpacity(0.15),
          child: Icon(Icons.class_, color: Colors.teal, size: 24),
        ),
        title: Text(
          item.name,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle:
            faixaEtaria.isNotEmpty
                ? Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(0xFF1565C0).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        faixaEtaria,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                    ),
                  ],
                )
                : null,
        trailing: PopupMenuButton(
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  value: 'excluir',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 20),
                      SizedBox(width: 10),
                      Text('Excluir'),
                    ],
                  ),
                ),
              ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget conteudo;
    if (isLoading) {
      conteudo = Center(child: CircularProgressIndicator());
    } else if (turmas.isEmpty) {
      conteudo = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.class_outlined, size: 64, color: Color(0xFFBDBDBD)),
            SizedBox(height: 16),
            Text(
              'Nenhuma turma cadastrada',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Color(0xFF757575),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    } else {
      conteudo = Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: SearchBar(
              elevation: WidgetStateProperty.all(2.3),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: searchTurma,
              leading: Icon(Icons.search),
              hintText: 'Procurar turma',
              hintStyle: WidgetStateProperty.all(
                Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9A9A9A),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          pesquisando == false
              ? Expanded(
                child: ListView.builder(
                  controller: _controller,
                  itemCount: turmas.length + 1,
                  itemBuilder: (context, index) {
                    if (index < turmas.length) {
                      return _buildTurmaItem(turmas[index]);
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
              )
              : Expanded(
                child:
                    resultadoPesquisa.isEmpty
                        ? Center(child: Text('Nenhum resultado encontrado.'))
                        : ListView.builder(
                          itemCount: resultadoPesquisa.length,
                          itemBuilder: (context, index) {
                            return _buildTurmaItem(resultadoPesquisa[index]);
                          },
                        ),
              ),
        ],
      );
    }
    return Material(
      child: Scaffold(
        appBar: CriarAppBar(context, 'Gerenciar Turmas'),
        body: conteudo,
        floatingActionButton: FloatingActionButton(
          onPressed: _abrirCadastroTurma,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
