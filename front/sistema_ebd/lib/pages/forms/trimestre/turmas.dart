import 'package:flutter/material.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';

class AlocacaoTurmas extends StatefulWidget {
  const AlocacaoTurmas({super.key});

  @override
  State<AlocacaoTurmas> createState() => _AlocacaoTurmasState();
}

class _AlocacaoTurmasState extends State<AlocacaoTurmas> {
  bool? select = false;
  get conteudo {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 18, right: 18),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Selecione as turmas que irão compor o trimestre',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: ListView(
              children: [
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
                'Continuar',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlocacaoTurmas()),
                );
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
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: CriarAppBar(context, 'Alocar Turmas'),
        body: conteudo,
      ),
    );
  }
}
