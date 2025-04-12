import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
class Professores extends StatefulWidget {
  final String turma;
  Professores({super.key, required this.turma});

  @override
  State<Professores> createState() => _ProfessoresState();
}

class _ProfessoresState extends State<Professores> {

  bool? select = false;
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
            
            child: ListView(
              children: 
              
              [
                ListTile(
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
                          select!
                              ? Color(0xFF008000)
                              : Color.fromARGB(250, 231, 230, 237),
                      width: 1.6,
                    ),
                  ),
                  tileColor: select! ? Color(0xFFCBEFCB) : Colors.white,
                  title: Text(
                    'Teste',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: select! ? Color(0xFF008000) : Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  trailing: Checkbox(
                    value: select,
                    activeColor: Color(0xFF008000),
                    onChanged: (value) {
                      setState(() {
                        select = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              child: Text(
                'Alocar Professores',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
    return Material(
      child: Scaffold(
        appBar: CriarAppBar(context,widget.turma),
        body: conteudo,
      ),
    );
    
  }
}