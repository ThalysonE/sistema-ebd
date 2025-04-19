import 'package:flutter/material.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/models/turma.dart';
import 'package:sistema_ebd/pages/forms/trimestre/lista_professores.dart';

class AlocacaoProfessores extends StatefulWidget {
  final List<Turma> turmasSelecionadas;
  const AlocacaoProfessores({super.key, required this.turmasSelecionadas});

  @override
  State<AlocacaoProfessores> createState() => _AlocacaoProfessoresState();
}

class _AlocacaoProfessoresState extends State<AlocacaoProfessores> {
  get conteudo {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 18, right: 18),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Selecione a turma que deseje alocar professores',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.copyWith(fontSize: 13),
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: widget.turmasSelecionadas.length,
              itemBuilder: (context, index) {
                Turma item = widget.turmasSelecionadas[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: Color.fromARGB(218, 231, 230, 237),
                      ),
                      bottom: BorderSide(
                        width: 1,
                        color: Color.fromARGB(218, 231, 230, 237),
                      ),
                      right: BorderSide(
                        width: 1,
                        color: Color.fromARGB(218, 231, 230, 237),
                      ),
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Professores(turma: item.name),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border(
                          left: BorderSide(
                            width: 10,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium!.copyWith(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Professores: 0',
                              style: Theme.of(
                                context,
                              ).textTheme.labelMedium!.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        tileColor: Colors.white,
                        trailing: Icon(Icons.chevron_right, size: 32),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
        bottomNavigationBar: Container(
          color: Color(0xFFfaf9fe),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 100),
                backgroundColor: Color(0xFF1565C0),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Continuar',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
