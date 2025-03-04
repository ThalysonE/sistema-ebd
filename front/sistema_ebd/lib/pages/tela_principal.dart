import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sistema_ebd/pages/tela_em_andamento.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int itemMenu = 0;

  Widget ListaOpcoes() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 135,
          padding: EdgeInsets.only(top: 25, left: 30, right: 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Color.fromARGB(255, 6, 94, 172),
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              stops: [0.4, 0.8],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, seja bem vindo!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Color(0xFFE3E3E3),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Professor!👋',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Image.asset(
                'assets/images/icon_perfil.png',
                height: 50,
                width: 50,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 25, bottom: 20, left: 28, right: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aulas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 137,
                      child: Card(
                        child: InkWell(
                          highlightColor: Color.fromARGB(108, 101, 149, 231),
                          splashColor: const Color.fromARGB(108, 101, 149, 231),
                          onTap: () {
                            print('foi');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/icone_opcoes/registro_aula_icon.png',
                                  width: 63,
                                  height: 63,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Registro de Aulas',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium?.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 137,
                      child: Card(
                        child: InkWell(
                          highlightColor: Color.fromARGB(108, 101, 149, 231),
                          splashColor: const Color.fromARGB(108, 101, 149, 231),
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/icone_opcoes/cadastro_aula_icon.png',
                                  width: 63,
                                  height: 63,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Cadastrar Aula',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium?.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 28, right: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sobre o Aluno',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 137,
                      child: Card(
                        child: InkWell(
                          highlightColor: Color.fromARGB(108, 101, 149, 231),
                          splashColor: const Color.fromARGB(108, 101, 149, 231),
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/icone_opcoes/gerenciar_membros_icon.png',
                                  width: 63,
                                  height: 63,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Gerenciar Membros',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium?.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 137,
                      child: Card(
                        child: InkWell(
                          highlightColor: Color.fromARGB(108, 101, 149, 231),
                          splashColor: const Color.fromARGB(108, 101, 149, 231),
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/icone_opcoes/gerenciar_classe_icon.png',
                                  width: 63,
                                  height: 63,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Gerenciar Classe',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium?.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Color(0xFFfaf9fe),
        body: SingleChildScrollView(
          child: itemMenu == 0 ? ListaOpcoes() : TelaEmAndamento(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 28,
          currentIndex: itemMenu,
          onTap: (index) {
            setState(() {
              itemMenu = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Aulas',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
