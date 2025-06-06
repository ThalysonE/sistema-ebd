import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/usuarios_repositories.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/models/usuario.dart';
import 'package:sistema_ebd/models/usuarioLogado.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class Professores extends ConsumerStatefulWidget {
  final String turma;
  const Professores({super.key, required this.turma});

  @override
  ConsumerState<Professores> createState() => _ProfessoresState();
}
class _ProfessoresState extends ConsumerState<Professores> {
  final ScrollController _controller = ScrollController();
  bool? select = false;
  late UsuarioLogado usuarioLog;
  List<Usuario> professores = [];
  final requisicaoUsuario = UsuariosRepository(); 
  bool fetchMaisProfessores = false;
  int numeroPage = 1;
  bool loadingPage = true;
  @override
  void initState() {
    super.initState();
    usuarioLog = ref.read(usuarioLogado);
    fetchProfessores(numeroPage++).then((_){
      loadingPage = false;
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
      final resposta = await requisicaoUsuario.getUsuariosRole(numeroPage: page, token: usuarioLog.token, cargo: 'TEACHER');
      professores.addAll(resposta);
      setState(() {
        
      });
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
                  Usuario usuario = professores[index];
                  return ListTile(
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
                    usuario.userName,
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
                Navigator.pop(context);
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
    return Material(
      child: Scaffold(
        appBar: CriarAppBar(context,widget.turma),
        body: loadingPage? Center(child: CircularProgressIndicator()): conteudo
      ),
    );
    
  }
}