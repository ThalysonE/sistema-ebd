import 'package:flutter/material.dart';
import 'package:sistema_ebd/pages/sobre.dart';
import 'package:sistema_ebd/pages/tela_usuarios.dart';

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({super.key});

  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFfaf9fe),
      child: Column(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 135,
                    color: const Color.fromARGB(228, 24, 68, 143),
                  ),
                  SizedBox(width: double.infinity, height: 35),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CircleAvatar(
                  maxRadius: 50,
                  minRadius: 40,
                  child: Image.asset('assets/images/icon_perfil.png'),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: [
              Text(
                'Professor',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Jhonny Cardoso',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(218, 231, 230, 237),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    subtitle: Text(
                      'Visualize ou edite seus dados',
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(fontSize: 12),
                    ),
                    leading: Icon(
                      Icons.settings,
                      color: Color(0xFF1565C0),
                      size: 28,
                    ),
                    title: Text(
                      'Meus Dados',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Color(0xFF1565C0),
                      size: 35,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(218, 231, 230, 237),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> TelaUsuarios(temSelecao: false)));
                    },
                    subtitle: Text(
                      'Adicione ou edite os dados dos usuários',
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(fontSize: 12),
                    ),
                    leading: Icon(
                      Icons.people,
                      color: Color(0xFF1565C0),
                      size: 28,
                    ),
                    title: Text(
                      'Gerenciar Usuários',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Color(0xFF1565C0),
                      size: 35,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(218, 231, 230, 237),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    subtitle: Text(
                      'Sobre o desenvolvimento',
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(fontSize: 12),
                    ),
                    leading: Icon(
                      Icons.info,
                      color: Color(0xFF1565C0),
                      size: 28,
                    ),
                    title: Text(
                      'Sobre',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Color(0xFF1565C0),
                      size: 35,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Sobre()),
                      );
                    },
                  ),
                ),
                SizedBox(height: 18),
                Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sair',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
