import 'package:flutter/material.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';

class AlocacaoProfessores extends StatefulWidget {
  const AlocacaoProfessores({super.key});

  @override
  State<AlocacaoProfessores> createState() => _AlocacaoProfessoresState();
}

class _AlocacaoProfessoresState extends State<AlocacaoProfessores> {
  bool? select = false;
  void professores() async{
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Professores'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(title: Text('Teste'),)
            ],
          ),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.delete))
          ],
        );
      },
    );
  }

  get conteudo {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 18, right: 18),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Selecione as turmas que irão compor o trimestre',
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.copyWith(fontSize: 14),
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  onTap: professores,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Color.fromARGB(250, 231, 230, 237),
                      width: 1.6,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Abraão',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Professores: 0',
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium!.copyWith(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  tileColor: Colors.white,

                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
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
              onPressed: () {},
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
        appBar: CriarAppBar(context, 'Alocar Professores'),
        body: conteudo,
      ),
    );
  }
}
