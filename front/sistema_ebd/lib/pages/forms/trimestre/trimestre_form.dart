import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/trimestre_repositories.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/models/usuarioLogado.dart';
import 'package:sistema_ebd/pages/turmas.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class TrimestreForm extends ConsumerStatefulWidget {
  const TrimestreForm({super.key});

  @override
  ConsumerState<TrimestreForm> createState() => _TrimestreFormState();
}

class _TrimestreFormState extends ConsumerState<TrimestreForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController periodoController = TextEditingController();
  TextEditingController dataControllerInicio = TextEditingController();
  TextEditingController dataControllerPrecisao = TextEditingController();

  final trimestreRepositorio = TrimestreRepository();
  late UsuarioLogado usuarioLog;
  int numPeriodo = 1;
  bool isLoadingCadastro = false;
  @override
  void initState() {
    super.initState();
    usuarioLog = ref.read(usuarioLogado);
    dataControllerInicio.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    dataControllerPrecisao.text = DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: 7 * 12)));
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
  Future<void>cadastroTrimestre() async{
    setState(() {
      isLoadingCadastro = true;
    });
    if(formKey.currentState!.validate()){
      int ano = DateFormat('dd/MM/yyyy').parse(dataControllerInicio.text).year;
      final dataInicio = DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(dataControllerInicio.text));
      final dataFim = DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(dataControllerPrecisao.text));
      try{
        final idTrimestre = await trimestreRepositorio.postTrimestre(token: usuarioLog.token, titulo: periodoController.text, ano: ano, numTrimestre: numPeriodo, dataInicio: dataInicio, dataFim: dataFim);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Turmas(temCadastro: false, idTrimestre: idTrimestre,),
          ),
        );
      }catch(e){
        showError(e.toString());
      }
    }
    setState(() {
      isLoadingCadastro = false;
    });
  } 
  Widget conteudo(context) {
    return Padding(
      padding: EdgeInsets.only(top: 40, right: 25, left: 25),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Período',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            DropdownMenu(
              controller: periodoController,
              onSelected: (value){
                if(value!=null){
                  numPeriodo = value;
                }
              },
              textStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1.5, color: Color(0xFFD0D5DD)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5,
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              width: double.infinity,
              initialSelection: 1,
              
              dropdownMenuEntries: [
                DropdownMenuEntry(value: 1, label: '1° Trimestre'),
                DropdownMenuEntry(value: 2, label: '2° Trimestre'),
                DropdownMenuEntry(value: 3, label: '3° Trimestre'),
                DropdownMenuEntry(value: 4, label: '4° Trimestre'),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Data de Inicio',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: dataControllerInicio,
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                prefixIcon: Icon(Icons.date_range),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1.5, color: Color(0xFFD0D5DD)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 1.5,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              validator: (value) {
                final dataInicio = DateFormat('dd/MM/yyyy').parse(dataControllerInicio.text);
                final dataFim = DateFormat('dd/MM/yyyy').parse(dataControllerPrecisao.text);
                if(dataInicio.isAfter(dataFim)){
                  return 'Data de início maior que a data de previsão de termino';
                }
                return null;
              },
              onTap: () async {
                final dataSelecionada = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2025),
                  lastDate: DateTime.now().add(Duration(days: 1900)),
                );
                if (dataSelecionada != null) {
                  dataControllerInicio.text = DateFormat(
                    'dd/MM/yyyy',
                  ).format(dataSelecionada);
                  dataControllerPrecisao.text = DateFormat(
                    'dd/MM/yyyy',
                  ).format(dataSelecionada.add(Duration(days: 7 * 12)));
                }
              },
            ),
            SizedBox(height: 40),
            Text(
              'Data Prevista de Termino',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: dataControllerPrecisao,
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                prefixIcon: Icon(Icons.date_range),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1.5, color: Color(0xFFD0D5DD)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 1.5,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              validator: (value){
                final dataInicio = DateFormat('dd/MM/yyyy').parse(dataControllerInicio.text);
                final dataFim = DateFormat('dd/MM/yyyy').parse(dataControllerPrecisao.text);
                if(dataInicio.isAfter(dataFim)){
                  return 'Data de previsão de termino é menor que a data de início';
                }
                return null;
              },
              onTap: () async {
                final dataSelecionada = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2025),
                  lastDate: DateTime.now().add(Duration(days: 1900)),
                );
                if (dataSelecionada != null) {
                  dataControllerPrecisao.text = DateFormat(
                    'dd/MM/yyyy',
                  ).format(dataSelecionada);
                }
              },
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: isLoadingCadastro? null: cadastroTrimestre,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 100),
                  backgroundColor: Color(0xFF1565C0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: isLoadingCadastro
                  ? SizedBox(
                    width: 20,
                    height: 20,
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
                  ) ,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: CriarAppBar(context, 'Cadastro Trimestre'),
        body: conteudo(context),
      ),
    );
  }
}
