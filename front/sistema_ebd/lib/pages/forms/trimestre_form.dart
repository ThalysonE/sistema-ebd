import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';

class TrimestreForm extends StatefulWidget {
  const TrimestreForm({super.key});

  @override
  State<TrimestreForm> createState() => _TrimestreFormState();
}

class _TrimestreFormState extends State<TrimestreForm> {
  TextEditingController periodoController = TextEditingController();
  TextEditingController dataControllerInicio = TextEditingController();
  TextEditingController dataControllerPrecisao = TextEditingController();

  @override
  void initState() {
    super.initState();
    dataControllerInicio.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }
  Widget conteudo(context) {
  return Padding(
    padding: EdgeInsets.only(top: 40, right: 25, left: 25),
    child: Form(
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
            textStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
              fontSize: 14
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
          SizedBox(height: 8,),
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
            onTap: () async{
              final dataSelecionada = await showDatePicker(
                context: context, 
                firstDate: DateTime(2025), 
                lastDate: DateTime.now().add(Duration(days: 150))
              );
              if(dataSelecionada!=null){
                dataControllerInicio.text = DateFormat('dd/MM/yyyy').format(dataSelecionada);
              dataControllerPrecisao.text = DateFormat('dd/MM/yyyy').format(dataSelecionada.add(Duration(days: )));
              }
            },
          ),
          SizedBox(height: 40,),
          Text(
            'Data Prevista de Termino',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8,),
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
            onTap: () async{
              final dataSelecionada = await showDatePicker(
                context: context, 
                firstDate: DateTime(2025), 
                lastDate: DateTime.now().add(Duration(days: 150))
              );
              if(dataSelecionada!=null){
                print(dataSelecionada.toString());
                dataControllerInicio.text = DateFormat('dd/MM/yyyy').format(dataSelecionada);
              }
            },
          ),
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


