import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/usuarios_repositories.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/models/usuario.dart';
import 'dart:async';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/models/usuarioLogado.dart';
import 'package:sistema_ebd/pages/forms/cadastro_usuario_form.dart';

class TelaUsuarios extends ConsumerStatefulWidget {
  final bool temSelecao;
  TelaUsuarios({super.key, required this.temSelecao});

  @override
  ConsumerState<TelaUsuarios> createState() => _TelaUsuariosState();
}

class _TelaUsuariosState extends ConsumerState<TelaUsuarios> {
  final ScrollController _controller = ScrollController();
  Timer? _debounce;
  bool isLoading = true;
  bool novosUsuarios = false;
  bool pesquisando = false;
  List<Usuario> resultadoPesquisa = [];

  late UsuarioLogado userLog;
  int numeroPage = 1;
  UsuariosRepository usuariosRequisicao = UsuariosRepository();
  List<Usuario> usuarios = [];

  static const _rolesLabel = <String, String>{
    'COMMON': 'Estudante',
    'TEACHER': 'Professor',
    'SHEPHERD': 'Pastor',
    'PEDAGOGICAL_DEPARTMENT': 'Dept. Pedagógico',
    'SUPERINTENDENT': 'Superintendente',
    'SECRETARY': 'Secretário',
  };

  showError(String msg, int cor) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: cor == 1 ? Colors.red[400] : Colors.orange[400],
        duration: Duration(seconds: 2),
        content: Center(child: Text(msg)),
      ),
    );
  }

  Future<void> fetchUsuarios(int page) async {
    try {
      final resposta = await usuariosRequisicao.fetchUsuarios(
        numeroPage: page,
        token: userLog.token,
      );
      usuarios.addAll(resposta);
      setState(() {});
    } catch (e) {
      showError(e.toString(), 1);
    }
  }

  @override
  void initState() {
    super.initState();
    userLog = ref.read(usuarioLogado);
    fetchUsuarios(numeroPage++).then((_) {
      setState(() => isLoading = false);
    });
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (usuarios.length < totalUsuarios) {
          if (!novosUsuarios) {
            setState(() => novosUsuarios = true);
          }
          fetchUsuarios(numeroPage++);
        } else {
          setState(() => novosUsuarios = false);
        }
      }
    });
  }

  void searchUsuario(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 700), () {
      if (query.isEmpty) {
        setState(() => pesquisando = false);
        return;
      }
      setState(() {
        pesquisando = true;
        resultadoPesquisa =
            usuarios
                .where(
                  (u) =>
                      u.userName.toLowerCase().contains(query.toLowerCase()) ||
                      u.email.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      });
    });
  }

  Widget _buildUsuarioItem(Usuario item) {
    final cargoLabel = _rolesLabel[item.role] ?? item.role;
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
          item.userName,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.email,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: Color(0xFF757575),
              ),
            ),
            SizedBox(height: 2),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Color(0xFF1565C0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                cargoLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1565C0),
                ),
              ),
            ),
          ],
        ),
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
    super.dispose();
  }

  Future<void> _recarregarUsuarios() async {
    setState(() {
      usuarios.clear();
      numeroPage = 1;
      isLoading = true;
    });
    await fetchUsuarios(numeroPage++);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    Widget conteudo;
    if (isLoading) {
      conteudo = Center(child: CircularProgressIndicator());
    } else if (usuarios.isEmpty) {
      conteudo = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Color(0xFFBDBDBD)),
            SizedBox(height: 16),
            Text(
              'Nenhum usuário cadastrado',
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
              onChanged: searchUsuario,
              leading: Icon(Icons.search),
              hintText: 'Procurar usuário',
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
                  itemCount: usuarios.length + 1,
                  itemBuilder: (context, index) {
                    if (index < usuarios.length) {
                      return _buildUsuarioItem(usuarios[index]);
                    } else {
                      return Padding(
                        padding: EdgeInsets.all(30),
                        child: Center(
                          child:
                              novosUsuarios
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
                            return _buildUsuarioItem(resultadoPesquisa[index]);
                          },
                        ),
              ),
        ],
      );
    }
    return Material(
      child: Scaffold(
        appBar: CriarAppBar(context, "Controle de Usuários"),
        body: conteudo,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            final resultado = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CadastroUsuarioForm(),
              ),
            );
            if (resultado == true) {
              await _recarregarUsuarios();
            }
          },
        ),
      ),
    );
  }
}
