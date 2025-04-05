import 'package:flutter/material.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';

class AlocacaoProfessores extends StatefulWidget {
  const AlocacaoProfessores({super.key});

  @override
  State<AlocacaoProfessores> createState() => _AlocacaoProfessoresState();
}

class _AlocacaoProfessoresState extends State<AlocacaoProfessores> {
  void professores() async {
    return showDialog(
      context: context,
      builder: (context) {
        bool? select = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding:EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              titlePadding: EdgeInsets.all(0),
              actionsPadding: EdgeInsets.all(0),
              title: Container(
                padding: EdgeInsets.only(top: 18, bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  'Professores',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 450, minWidth: 1000),
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(10, (index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 5),
                        padding: EdgeInsets.only(
                          top: 0,
                          bottom: 0,
                          left: 10,
                          right: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                select!
                                    ? Color(0xFF008000)
                                    : Color.fromARGB(250, 231, 230, 237),
                            width: 1.6,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Teste',
                              style: Theme.of(
                                context,
                              ).textTheme.labelMedium!.copyWith(
                                color:
                                    select! ? Color(0xFF008000) : Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            Checkbox(
                              value: select,
                              activeColor: Color(0xFF008000),
                              onChanged: (value) {
                                setState(() {
                                  select = value;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                      // return SizedBox(
                      //   height: 50,
                      //   child: ListTile(

                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //       side: BorderSide(
                      //         color:
                      //             select!
                      //                 ? Color(0xFF008000)
                      //                 : Color.fromARGB(250, 231, 230, 237),
                      //         width: 1.6,
                      //       ),
                      //     ),
                      //     tileColor: select! ? Color(0xFFCBEFCB) : Colors.white,
                      //     title: Text(
                      //       'Teste',
                      //       style: Theme.of(
                      //         context,
                      //       ).textTheme.labelMedium!.copyWith(
                      //         color: select! ? Color(0xFF008000) : Colors.black,
                      //         fontSize: 15,

                      //       ),
                      //     ),
                      //     trailing: Checkbox(
                      //       value: select,
                      //       activeColor: Color(0xFF008000),
                      //       onChanged: (value) {
                      //         setState(() {
                      //           select = value;
                      //         });
                      //       },
                      //     ),
                      //   ),
                      // );
                    }),
                  ),
                ),
              ),
              actions: [
                Container(
                  padding: EdgeInsets.only(bottom: 10, top: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: Text(
                        'Finalizar',
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
                        padding: EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 100,
                        ),
                        backgroundColor: Color(0xFF1565C0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
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
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.copyWith(fontSize: 13),
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
