import 'package:flutter/material.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  GlobalKey<ScaffoldState> keyScafold = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: keyScafold,
      appBar: CriarAppBar(context, 'Sobre'),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: ListView(
          children: [
            ListTile(
              onTap: () {
                keyScafold.currentState!.showBottomSheet((context) {
                  return Container(
                    padding: EdgeInsets.only(top: 10, bottom: 80, left: 25),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 1.5,
                          color: Color.fromARGB(218, 220, 219, 228)
                        )
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 7,
                          width: 120,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(134, 175, 175, 175),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset('assets/images/github.png'),
                            SizedBox(width: 8),
                            Text(
                              'GitHub',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineMedium?.copyWith(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Row(
                          children: [
                            Icon(Icons.logo_dev),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: (){
                                launchUrl(Uri.parse('https://github.com/ThalysonE'), mode: LaunchMode.externalApplication);
                              },
                              child: Text(
                                'https://github.com/ThalysonE',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 36),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.logo_dev),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: (){
                                launchUrl(Uri.parse('https://github.com/oyurisousa'), mode: LaunchMode.externalApplication);
                              },
                              child: Text(
                                'https://github.com/oyurisousa',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
              },
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
