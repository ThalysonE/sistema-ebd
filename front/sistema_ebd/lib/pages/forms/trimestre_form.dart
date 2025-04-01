import 'package:flutter/material.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';

class TrimestreForm extends StatefulWidget {
  const TrimestreForm({super.key});

  @override
  State<TrimestreForm> createState() => _TrimestreFormState();
}

class _TrimestreFormState extends State<TrimestreForm> {
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
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.red
                )
              )
            ),
            menuStyle: MenuStyle(
              //shape: MaterialStateProperty.all()
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
        ],
      ),
    ),
  );
}
