import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/Data/providers/membros_provider.dart';
import 'package:sistema_ebd/models/membro.dart';

class TelaMembros extends ConsumerStatefulWidget {
  const TelaMembros({super.key});

  @override
  ConsumerState<TelaMembros> createState() => _TelaMembrosState();
}

class _TelaMembrosState extends ConsumerState<TelaMembros> {
  late List<Membro> membros;
  int numeroPage = 1;
  ScrollController _controller = ScrollController();
  bool isLoading = true;

  void fetchMembros(int _page) async {
    await ref.read(listaMembros.notifier).loadMembros(page: _page).then((_){
        setState(() {
        });
      }
    );
  }
  
  @override
  void initState(){
    super.initState();
    
    ref.read(listaMembros.notifier).loadMembros(page: numeroPage).then((_){
      setState(() {
        isLoading = false;
      });
    });
    
    _controller.addListener((){
      if(_controller.position.maxScrollExtent == _controller.offset){
        fetchMembros(++numeroPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    membros = ref.watch(listaMembros);
    print(membros);

    Widget conteudo;
    if(isLoading){
      conteudo = Center(child: CircularProgressIndicator());
    }else{
      conteudo = ListView.builder(
          controller: _controller,
          itemCount: membros.length + 1,
          itemBuilder: (context, index) {
            if (index < membros.length) {
              final item = membros[index];
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  item.nome,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        );
    }
    return Scaffold(
      body: conteudo
      );
  }
}
