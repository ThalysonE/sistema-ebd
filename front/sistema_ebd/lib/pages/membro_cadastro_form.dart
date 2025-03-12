import 'package:flutter/material.dart';
import 'package:sistema_ebd/utils/appbar.dart';
import 'package:intl/intl.dart';

class MembroCadastro extends StatefulWidget {
  const MembroCadastro({super.key});

  @override
  State<MembroCadastro> createState() => _MembroCadastroState();
}

class _MembroCadastroState extends State<MembroCadastro> {
  DateTime? dataNasc;
  TextEditingController _dateController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyy').format(DateTime.now());
  }

  Future<void> selecionarData() async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (dataSelecionada != null) {
      setState(() {
        _dateController.text =
            DateFormat('dd/MM/yyyy').format(dataSelecionada).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: CriarAppBar(context, "Adicionar Membro"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
            child: Form(
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
                    controller: _dateController,
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

                    initialSelection: 'masc',
                    enableSearch: false,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: 'masc', label: 'Masculino'),
                      DropdownMenuEntry(value: 'fem', label: 'Feminino'),
                    ],
                    onSelected: (selecao) {},
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ElevatedButton.icon(
            icon: Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 13, horizontal: 100),
              backgroundColor: Color(0xFF1565C0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            label: Text(
              'Cadastrar',
              style: Theme.of(context,).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontSize: 15
              ),
            ),
          ),
        ),
      ),
    );
  }
}
