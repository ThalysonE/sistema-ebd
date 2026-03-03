import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/matricula_repositories.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/models/matricula.dart';
import 'package:sistema_ebd/models/usuarioLogado.dart';
import 'dart:async';

class TelaAlunosMatriculados extends ConsumerStatefulWidget {
  final String idTurmaTrimestre;
  final String nomeTurma;

  const TelaAlunosMatriculados({
    super.key,
    required this.idTurmaTrimestre,
    required this.nomeTurma,
  });

  @override
  ConsumerState<TelaAlunosMatriculados> createState() =>
      _TelaAlunosMatriculadosState();
}

class _TelaAlunosMatriculadosState
    extends ConsumerState<TelaAlunosMatriculados> {
  final ScrollController _controller = ScrollController();
  Timer? _debounce;
  bool isLoading = true;
  bool novosAlunos = false;
  bool pesquisando = false;
  List<Matricula> resultadoPesquisa = [];

  late UsuarioLogado userLog;
  int numeroPage = 1;
  MatriculaRepository matriculaRequisicao = MatriculaRepository();
  List<Matricula> alunos = [];

  showError(String msg) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 2),
        content: Center(child: Text(msg)),
      ),
    );
  }

  Future<void> fetchAlunos(int page) async {
    try {
      final resposta = await matriculaRequisicao.getMatriculas(
        numeroPage: page,
        token: userLog.token,
        trimesterRoomId: widget.idTurmaTrimestre,
      );
      alunos.addAll(resposta);
      setState(() {});
    } catch (e) {
      showError(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    userLog = ref.read(usuarioLogado);
    fetchAlunos(numeroPage++).then((_) {
      setState(() => isLoading = false);
    });
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (alunos.length < totalMatriculas) {
          if (!novosAlunos) {
            setState(() => novosAlunos = true);
          }
          fetchAlunos(numeroPage++);
        } else {
          setState(() => novosAlunos = false);
        }
      }
    });
  }

  void searchAluno(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 700), () {
      if (query.isEmpty) {
        setState(() => pesquisando = false);
        return;
      }
      setState(() {
        pesquisando = true;
        resultadoPesquisa =
            alunos
                .where(
                  (a) => a.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      });
    });
  }

  Widget _buildAlunoItem(Matricula aluno) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(218, 231, 230, 237), width: 1),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 10),
        leading: Image.asset('assets/images/icon_perfil.png', width: 36),
        title: Text(
          aluno.name,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: 4),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Color(0xFF43A047).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Matriculado',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF43A047),
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, size: 28, color: Colors.grey),
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
    } else if (alunos.isEmpty) {
      conteudo = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Color(0xFFBDBDBD)),
            SizedBox(height: 16),
            Text(
              'Nenhum aluno matriculado',
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
              onChanged: searchAluno,
              leading: Icon(Icons.search),
              hintText: 'Procurar aluno',
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
                  itemCount: alunos.length + 1,
                  itemBuilder: (context, index) {
                    if (index < alunos.length) {
                      return _buildAlunoItem(alunos[index]);
                    } else {
                      return Padding(
                        padding: EdgeInsets.all(30),
                        child: Center(
                          child:
                              novosAlunos
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
                            return _buildAlunoItem(resultadoPesquisa[index]);
                          },
                        ),
              ),
        ],
      );
    }
    return Material(
      child: Scaffold(
        appBar: CriarAppBar(context, widget.nomeTurma),
        body: conteudo,
      ),
    );
  }
}
