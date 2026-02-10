import 'package:flutter/material.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/usuarios_repositories.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/models/membro.dart';
import 'package:sistema_ebd/models/usuario.dart';
import 'package:sistema_ebd/models/usuarioLogado.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class Professores extends ConsumerStatefulWidget {
  final String turma;
  final List<dynamic> professoresRemover; // professores que já foram selecionados em outras turmas
  final List<dynamic> listaProfessoresSelecionados; // professores que já foram selecionados para a turma atual
  const Professores({super.key, required this.turma, required this.professoresRemover, required this.listaProfessoresSelecionados});

  @override
  ConsumerState<Professores> createState() => _ProfessoresState();
}
class _ProfessoresState extends ConsumerState<Professores> {
  final ScrollController _controller = ScrollController();
  bool? select = false;
  late UsuarioLogado usuarioLog;
  List<Membro> professores = [];
  final requisicaoUsuario = UsuariosRepository(); 
  bool fetchMaisProfessores = false;
  int numeroPage = 1;
  bool loadingPage = true;
  @override
  void initState() {
    super.initState();
    usuarioLog = ref.read(usuarioLogado);
    fetchProfessores(numeroPage++).then((_){
      setState(() {
        loadingPage = false;
      });
    });
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (professores.length < totalUsuarios) {
          if (!fetchMaisProfessores) {
            setState(() {
              fetchMaisProfessores = true;
            });
          }
          fetchProfessores(numeroPage++);
        } else {
          setState(() {
            fetchMaisProfessores = false;
          });
        }
      }
    });
  }
  Future<void> fetchProfessores(int page) async{
    try{
      List<Membro> resposta = await requisicaoUsuario.fetchUsuariosParaMembro(numeroPage: page, token: usuarioLog.token, cargo: 'TEACHER');
      if(!resposta.isEmpty){
        resposta.removeWhere((item)=> widget.professoresRemover.contains(item.idUsuario));
        for(final item in resposta){
          if(widget.listaProfessoresSelecionados.contains(item.idUsuario)){
            item.selectBox = true;
          }
        }
        setState(() {
          professores.addAll(resposta);
        });
      }
    }catch(e){
      showError(e.toString());
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final conteudo = Padding(
      padding: EdgeInsets.only(top: 30, left: 18, right: 18),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Selecione os professores para a classe ${widget.turma}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: professores.length + 1,
              itemBuilder: (context,index){
                if(index< professores.length){
                  Membro usuario = professores[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: ListTile(
                    contentPadding: EdgeInsets.only(
                      top: 0,
                      bottom: 0,
                      right: 4,
                      left: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color:
                            usuario.selectBox
                                ? Color(0xFF008000)
                                : Color.fromARGB(250, 231, 230, 237),
                        width: 1.6,
                      ),
                      
                    ),
                    tileColor: usuario.selectBox ? Color(0xFFCBEFCB) : Colors.white,
                    title: Text(
                      usuario.nome,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: usuario.selectBox ? Color(0xFF008000) : Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    trailing: Checkbox(
                      value: usuario.selectBox,
                      activeColor: Color(0xFF008000),
                      onChanged: (value) {
                        setState(() {
                          usuario.selectBox = value!;
                        });
                      },
                    ),
                                    ),
                  );
                }else{
                  return Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child:
                          fetchMaisProfessores
                              ? CircularProgressIndicator()
                              : SizedBox(height: 25),
                    ),
                  );
                }
              
            }
          ,)
          ),
          Spacer(),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                List<String> listaIdProfessores = [];
                for(Membro professor in professores){
                  if(professor.selectBox){
                    listaIdProfessores.add(professor.idUsuario);
                  }
                }
                Navigator.pop(context, listaIdProfessores);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 100),
                backgroundColor: Color(0xFF1565C0),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Alocar Professores',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
    final msgVazio = Center(
      child: Text('Nenhum professor disponível')
    );
    return Material(
      child: Scaffold(
        appBar: CriarAppBar(context,widget.turma),
        body: loadingPage? Center(child: CircularProgressIndicator()): professores.isEmpty? msgVazio: conteudo
      ),
    );
    
  }
}