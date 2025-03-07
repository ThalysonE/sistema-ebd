import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/Data/providers/membros_provider.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/models/membro.dart';

class TelaMembros extends ConsumerStatefulWidget {
  const TelaMembros({super.key});

  @override
  ConsumerState<TelaMembros> createState() => _TelaMembrosState();
}

class _TelaMembrosState extends ConsumerState<TelaMembros> {
  late List<Membro> membros;
  ScrollController _controller = ScrollController();
  bool isLoading = true;
  bool novosMembros = true;
  void fetchMembros(int _page) async {
    await ref.read(listaMembros.notifier).loadMembros(page: _page).then((_) {
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
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if(ref.read(listaMembros).length < totalMembros){
          fetchMembros(++paginaAtual);
        }else{
          
          setState(() {
            novosMembros = false;
          });
        }
      }
    });
  }
  void SearchMember(){

  }
  @override
  Widget build(BuildContext context) {
    membros = ref.watch(listaMembros);
    Widget conteudo;
    if (isLoading) {
      conteudo = Center(child: CircularProgressIndicator());
    } else {
      conteudo = Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: SearchBar(
              elevation: MaterialStateProperty.all(2.3),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              leading: Icon(Icons.search),
              hintText: 'Procurar',
              hintStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9A9A9A),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: membros.length + 1,
              itemBuilder: (context, index) {
                if (index < membros.length) {
                  final item = membros[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(218, 231, 230, 237),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 16,
                        top: 4,
                        bottom: 4,
                        right: 10,
                      ),
                      leading: Image.asset(
                        'assets/images/icon_perfil.png',
                        width: 36,
                      ),
                      title: Text(
                        item.nome,
                        style: Theme.of(
                          context,
                        ).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder:
                            (context) => [
                              PopupMenuItem(
                                value: 'editar',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Text('Editar'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'excluir',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Text('Excluir'),
                                  ],
                                ),
                              ),
                            ],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(child: novosMembros? CircularProgressIndicator(): SizedBox(height: 25,)),
                  );
                }
              },
            ),
          ),
        ],
      );
    }
    return Material(
      child: Scaffold(
        backgroundColor: Color(0xFFfaf9fe),
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.chevron_left, size: 30),
            color: Colors.white,
          ),
          title: Text(
            'Controle de Membros',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 16.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        body: conteudo,
      ),
    );
  }
}
