import 'package:flutter/material.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/trimestre_repositories.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/models/trimestre/turma_trimestre.dart';
import 'package:sistema_ebd/models/usuarioLogado.dart';
import 'package:sistema_ebd/pages/forms/trimestre/lista_professores.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class AlocacaoProfessores extends ConsumerStatefulWidget {
  final String idTrimestre;
  const AlocacaoProfessores({super.key, required this.idTrimestre});

  @override
  ConsumerState<AlocacaoProfessores> createState() => _AlocacaoProfessoresState();
}

class _AlocacaoProfessoresState extends ConsumerState<AlocacaoProfessores> {
  final ScrollController _controller = ScrollController();
  late UsuarioLogado usuarioLog;

  bool isLoading = true; // carregar pagina
  bool fetchMaisTurmas = false; // loading do infinity scroll
  bool cadastrandoProfessores = false; //loading do cadastrar professores(quano clica em continuar)

  int numeroPage = 0; // numero pagina pra carregar turmas do trimestre(por algum motivo a requisiçaõ ta adicionadno mais 1 nessa variavel da pagina) 
  List<TurmaTrimestre> turmastrimestre = [];

  final trimestreTurmaRequisicao = TrimestreRepository();
  @override
  void initState() {
    super.initState();
    usuarioLog = ref.read(usuarioLogado);
    getTurmasTrimestre(numeroPage++).then((_){
      setState(() {
        isLoading = false;
      });
    });
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (turmastrimestre.length < totalTurmasTrimestre) {
          if (!fetchMaisTurmas) {
            setState(() {
              fetchMaisTurmas = true;
            });
          }
          getTurmasTrimestre(numeroPage++);
        } else {
          setState(() {
            fetchMaisTurmas = false;
          });
        }
      }
    });
  }

  List<Map<String,dynamic>> listaDeProfessoresAlocar = [];

  showError(String msg, int cor){
    return ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        backgroundColor: cor == 1? Colors.red[400]: Colors.orange[400],
        duration: Duration(seconds: 2),
        content: Center(
          child: Text(msg)
        )
      )
    );
  }
  Future<void> alocarProfessores()async{
    setState(() {
      cadastrandoProfessores = true;
    });
    try{
      for(final item in listaDeProfessoresAlocar){
        await trimestreTurmaRequisicao.alocarProfessoresTrimestre(token: usuarioLog.token, idTurmaTrimestre: item['idTrimesterRoom'], professoresId: item['idsProfessoresSelecionados']);
      }
      setState(() {
        cadastrandoProfessores = false;
      });
    }catch(e){
      showError(e.toString(), 1);
    }
  }
  Future<void> getTurmasTrimestre(int page)async{
    print('numero da pagina : ${page}');
    try{
      final resposta = await trimestreTurmaRequisicao.getTurmasTrimestre(numeroPage: numeroPage, token: usuarioLog.token, idTrimestre: widget.idTrimestre);
      setState(() {
        turmastrimestre.addAll(resposta);
      });
    }catch(e){
      showError(e.toString(), 1);
    }
  }

  direcionaPaginaProfessores(int index, item) async{
    List<dynamic> idsProfSelecionadosEmOutraTurma = [];
    List<dynamic> idsProfSelecionados  = listaDeProfessoresAlocar[index]["idsProfessoresSelecionados"];
    for(Map<String,dynamic> x in listaDeProfessoresAlocar){
      if(!x['idsProfessoresSelecionados'].isEmpty && x!= listaDeProfessoresAlocar[index]){
        idsProfSelecionadosEmOutraTurma.addAll(x['idsProfessoresSelecionados']);
      }
    }
    final retornoIdsProfessores = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Professores(turma: item.nome, listaProfessoresSelecionados: idsProfSelecionados, professoresRemover: idsProfSelecionadosEmOutraTurma,),
      ),
    );
    if(retornoIdsProfessores!= null){
      if(retornoIdsProfessores.length > idsProfSelecionados.length){
        for(final id in retornoIdsProfessores){
          if(!idsProfSelecionados.contains(id)){
            idsProfSelecionados.add(id);
            turmastrimestre[index].qtdProfessores += 1;
          }
        }
      }else if(retornoIdsProfessores.length < idsProfSelecionados.length){
        for(final id in List.from(idsProfSelecionados)){
          if(!retornoIdsProfessores.contains(id)){
            idsProfSelecionados.remove(id);
            turmastrimestre[index].qtdProfessores -= 1;
          }
        }
      }
      setState(() {
        turmastrimestre[index].qtdProfessores;
      });
      listaDeProfessoresAlocar[index]['idsProfessoresSelecionados'] = idsProfSelecionados;
    }
  }
  
  get conteudo {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 18, right: 18),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Selecione a turma que deseje alocar professores',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.copyWith(fontSize: 13),
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: turmastrimestre.length+1,
              controller: _controller,
              itemBuilder: (context, index) {
                
                if(index < turmastrimestre.length){
                  TurmaTrimestre item = turmastrimestre[index];
                  if(listaDeProfessoresAlocar.length < turmastrimestre.length){
                  listaDeProfessoresAlocar.add(
                    {
                      "idTrimesterRoom": item.id, 
                      "idsProfessoresSelecionados": []
                    }
                  );
                }
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: Color.fromARGB(218, 231, 230, 237),
                        ),
                        bottom: BorderSide(
                          width: 1,
                          color: Color.fromARGB(218, 231, 230, 237),
                        ),
                        right: BorderSide(
                          width: 1,
                          color: Color.fromARGB(218, 231, 230, 237),
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: (){
                        direcionaPaginaProfessores(index,item);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border(
                            left: BorderSide(
                              width: 10,
                              color: Colors.deepOrangeAccent,
                            ),
                          ),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.nome,
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
                              Text(
                                item.qtdProfessores.toString(),
                                style: Theme.of(
                                  context,
                                ).textTheme.labelMedium!.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: item.qtdProfessores == 0? Colors.red: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          tileColor: Colors.white,
                          trailing: Icon(Icons.chevron_right, size: 32),
                        ),
                      ),
                    ),
                  );
                }else{
                  return Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child:
                          fetchMaisTurmas
                              ? CircularProgressIndicator()
                              : SizedBox(height: 25),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: CriarAppBar(context, 'Alocar Professores'),
        body: isLoading
        ? Center(child: CircularProgressIndicator())
        : turmastrimestre.isEmpty
          ? Center(
            child: Text(
              'Nenhuma turma cadastrada no trimestre'
            ),
          ): conteudo,
        bottomNavigationBar: Container(
          color: Color(0xFFfaf9fe),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: ElevatedButton(
              onPressed: cadastrandoProfessores
                ? null
                : () {
                    if(listaDeProfessoresAlocar.isNotEmpty){
                      bool todasAsTurmasTemProfessor = true;
                      for(final x in turmastrimestre){
                        if(x.qtdProfessores==0){
                          todasAsTurmasTemProfessor = false;
                          break;
                        }
                      }
                      if(todasAsTurmasTemProfessor){
                        alocarProfessores();
                      }else{
                        showError('Todas as turmas precisam ter professores', 1);
                      }
                    }else{
                      showError('Nenhum professor selecionado', 2);
                    }
                },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 100),
                backgroundColor: Color(0xFF1565C0),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: cadastrandoProfessores
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Color(0xFF1565C0),
                    )
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
        ),
      ),
    );
  }
}
