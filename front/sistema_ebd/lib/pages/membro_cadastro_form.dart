import 'package:flutter/material.dart';
import 'package:sistema_ebd/utils/appbar.dart';

class MembroCadastro extends StatefulWidget {
  const MembroCadastro({super.key});

  @override
  State<MembroCadastro> createState() => _MembroCadastroState();
}

class _MembroCadastroState extends State<MembroCadastro> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Color(0xFFfaf9fe),
        appBar: CriarAppBar(context, "Adicionar Membro"),
        body: Padding(
          padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
          child: Form(
            child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nome', 
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 15,),
                TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Color(0xFFD0D5DD),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color:
                              Theme.of(
                                context,
                              ).buttonTheme.colorScheme!.primary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.5, color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color:
                              Theme.of(
                                context,
                              ).buttonTheme.colorScheme!.primary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    label: Text(
                      'Gabriel',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Color(0xFFAFADBE),
                          fontWeight: FontWeight.w700,
                        ),
                    ),

                  ),
                )
              ],
          )),
        ),
      ),
    );
  }
}