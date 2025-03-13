import 'package:flutter/material.dart';
import 'package:sistema_ebd/Data/providers/membros_provider.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/models/membro.dart';

class MembroForm extends ConsumerStatefulWidget {
  const MembroForm({super.key, this.membro});
  final Membro? membro;
  @override
  ConsumerState<MembroForm> createState() => _MembroFormState();
}

class _MembroFormState extends ConsumerState<MembroForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _dataController = TextEditingController();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _sexoController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _dataController.text =
        widget.membro == null
            ? DateFormat('dd/MM/yyy').format(DateTime.now())
            : widget.membro!.dataDeNascimento;
    _nomeController.text = widget.membro?.nome ?? '';
  }

  Future<void> selecionarData() async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate:
          widget.membro == null
              ? DateTime.now()
              : DateTime.parse(widget.membro!.dataDeNascimento),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (dataSelecionada != null) {
      setState(() {
        _dataController.text =
            DateFormat('dd/MM/yyyy').format(dataSelecionada).toString();
      });
    }
  }

  Future<void> cadastrarMembro() async {
    print(_sexoController.text);
    if (formKey.currentState!.validate()) {
      final nome = _nomeController.text;
      final dataNasc = DateFormat(
        'yyyy-MM-dd',
      ).format(DateFormat('dd/MM/yyyy').parse(_dataController.text));
      final sexo = _sexoController.text;

      final codigoResp = await ref
          .read(listaMembros.notifier)
          .cadastrarMembro(nome: nome, dataNasc: dataNasc, sexo: sexo);
      if (codigoResp == 201) {
        Navigator.pop(context);
        mostrarMsg('Membro cadastrado com sucesso!', 0);
      } else {
        mostrarMsg('Erro ao realizar o cadastro', 1);
      }
    }
  }

  mostrarMsg(String msg, int tipo) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: tipo == 0 ? Colors.green : Colors.red,
        content: Center(
          child: Text(
            msg,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _dataController.dispose();
    _sexoController.dispose();
    _nomeController.dispose();   
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: CriarAppBar(context, widget.membro == null? "Adicionar Membro": "Atualizar dados"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Color(0xFFD0D5DD),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color:
                              Theme.of(
                                context,
                              ).buttonTheme.colorScheme!.primary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.5, color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color:
                              Theme.of(
                                context,
                              ).buttonTheme.colorScheme!.primary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      label: Text(
                        'Gabriel',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Color(0xFFAFADBE),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O nome deve ter mais de 3 caracteres';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Data de Nascimento',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      prefixIcon: Icon(Icons.date_range),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Color(0xFFD0D5DD),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color:
                              Theme.of(
                                context,
                              ).buttonTheme.colorScheme!.primary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                    controller: _dataController,
                    onTap: selecionarData,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Sexo',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 15),
                  DropdownMenu(
                    controller: _sexoController,
                    width: 200,
                    textStyle: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Color(0xFFD0D5DD),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1.5,
                          color:
                              Theme.of(
                                context,
                              ).buttonTheme.colorScheme!.primary,
                        ),
                      ),
                    ),
                    initialSelection:
                        (widget.membro == null || widget.membro?.sexo == 'MALE')
                            ? 'masc'
                            : 'fem',
                    enableSearch: false,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: 'masc', label: 'Masculino'),
                      DropdownMenuEntry(value: 'fem', label: 'Feminino'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ElevatedButton.icon(
            icon: Icon(widget.membro ==null? Icons.add_circle_outline: Icons.edit, color: Colors.white),
            onPressed: cadastrarMembro,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 13, horizontal: 100),
              backgroundColor: Color(0xFF1565C0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            label: Text(
              widget.membro == null? 'Cadastrar': 'Atualizar',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
