import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/Data/providers/membros_provider.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/models/membro.dart';
import 'dart:async';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/pages/forms/membro_form.dart';

class TelaMembros extends ConsumerStatefulWidget {
  final bool temSelecao;
  TelaMembros({super.key, required this.temSelecao});

  @override
  ConsumerState<TelaMembros> createState() => _TelaMembrosState();
}

class _TelaMembrosState extends ConsumerState<TelaMembros> {
  final ScrollController _controller = ScrollController();
  Timer? _debounce;
  bool isLoading = true;
  bool novosMembros = false;
  bool pesquisando = false;
  List<Membro> resultadoPesquisa = [];
  Set<String> listaIdMembrosSelecionados = {};
  void fetchMembros(int page) async {
    await ref.read(listaMembros.notifier).loadMembros(page: page).then((_) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    if (ref.read(listaMembros).isEmpty) {
      ref.read(listaMembros.notifier).loadMembros(page: paginaAtual).then((_) {
        setState(() {
          isLoading = false;
        });
      });
    } else {
      isLoading = false;
    }
    _controller.addListener(() {
      final membroProvider = ref.read(listaMembros);
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (membroProvider.length < totalMembros) {
          if (!novosMembros) {
            setState(() {
              novosMembros = true;
            });
          }
          //print('Membros Provider: ${membroProvider.length} < Total Membros${totalMembros}');
          fetchMembros(++paginaAtual);
        } else {
          setState(() {
            novosMembros = false;
          });
        }
      }
    });
  }

  Widget retornaMembroItem(Membro item) {
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
          item.nome,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        trailing:
            widget.temSelecao == false
                ? PopupMenuButton(
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MembroForm(membro: item),
                              ),
                            );
                          },
                          value: 'editar',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.amber, size: 20),
                              SizedBox(width: 10),
                              Text('Editar'),
                            ],
                          ),
                        ),
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
                )
                : Checkbox(
                  value: listaIdMembrosSelecionados.contains(item.id),
                  onChanged: (value) {
                    if (value! == true) {
                      setState(() {
                      listaIdMembrosSelecionados.add(item.id);
                      });
                    } else if (value == false) {
                      setState(() {
                        listaIdMembrosSelecionados.remove(item.id);
                      });
                    }
                    print(listaIdMembrosSelecionados);
                  },
                ),
      ),
    );
  }

  void searchMembro(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 700), () async {
      List<Membro>? resultado = await ref
          .read(listaMembros.notifier)
          .searchMembro(nome: query);
      pesquisando = true;
      if (resultado == null) {
        print('Erro na pesquisa/sem internet para pesquisar');
        return;
      }
      setState(() {
        if (resultado.isNotEmpty) {
          resultadoPesquisa = resultado;
        }
        if (query.isEmpty) {
          pesquisando = false;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Membro> membros = ref.watch(listaMembros);
    Widget conteudo;
    if (isLoading) {
      conteudo = Center(child: CircularProgressIndicator());
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
              onChanged: searchMembro,
              leading: Icon(Icons.search),
              hintText: 'Procurar',
              hintStyle: WidgetStateProperty.all(
                Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9A9A9A),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          pesquisando == false
              ? Expanded(
                child: ListView.builder(
                  controller: _controller,
                  itemCount: membros.length + 1,
                  itemBuilder: (context, index) {
                    if (index < membros.length) {
                      final item = membros[index];
                      return retornaMembroItem(item);
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
              )
              : Expanded(
                child:
                    resultadoPesquisa.isEmpty
                        ? Center(child: Text('Nenhum resultado encontrado.'))
                        : ListView.builder(
                          itemCount: resultadoPesquisa.length,
                          itemBuilder: (context, index) {
                            final item = resultadoPesquisa[index];
                            return retornaMembroItem(item);
                          },
                        ),
              ),
        ],
      );
    }
    return Material(
      child: Scaffold(
        appBar: CriarAppBar(context, "Controle de Membros"),
        body: conteudo,
        floatingActionButton:
            widget.temSelecao == false
                ? FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.pushNamed(context, '/membro/cadastro');
                  },
                )
                : null,
      ),
    );
  }
}
