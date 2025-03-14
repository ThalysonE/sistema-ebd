import 'package:flutter/material.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';

class Sobre extends StatelessWidget {
  const Sobre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CriarAppBar(context, 'Sobre'),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: ListView(
          children: [
            ListTile(
              onTap: () {},
              splashColor: Color.fromARGB(33, 55, 111, 175),
              shape: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(218, 231, 230, 237),
                  width: 1,
                ),
              ),
              tileColor: Colors.white,
              leading: Icon(
                Icons.devices_outlined,
                color: Color(0xFF1565C0),
                size: 30,
              ),
              title: Text(
                'Desenvolvedores',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                ' Thalyson Elione\n Carlos Yuri\n Rhamon Asafe',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontSize: 14, height: 1.6),
              ),
            ),
            ListTile(
              onTap: () {},
              splashColor: Color.fromARGB(33, 55, 111, 175),
              tileColor: Colors.white,
              leading: Icon(
                Icons.assessment_outlined,
                color: Color(0xFF1565C0),
                size: 30,
              ),
              title: Text(
                'Versão aplicativo',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '1.0.0',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontSize: 14, height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
