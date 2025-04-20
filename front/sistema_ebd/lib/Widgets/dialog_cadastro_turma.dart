import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sistema_ebd/Data/repositories/turmas_repositories.dart';
import 'package:sistema_ebd/Widgets/listWhell.dart';

class CadastroDialog extends StatefulWidget {
  final usuarioToken;
  final Function() recarregarTurmas;
  final Function(int tipo) mostrarMsg;
  CadastroDialog({
    super.key,
    required this.usuarioToken,
    required this.recarregarTurmas,
    required this.mostrarMsg,
  });

  @override
  State<CadastroDialog> createState() => _CadastroDialogState();
}

final requisicaoTurmas = TurmasRepositories();

GlobalKey<FormState>? _formKey;
//variaveis para gerenciar a idade escolhida no form
ValueNotifier<int>? idadeMaxEscolhida;
ValueNotifier<int>? idadeMinEscolhida;

TextEditingController? _nomeController;
TextEditingController? _idadeMinController;
TextEditingController? _idadeMaxController;

class _CadastroDialogState extends State<CadastroDialog> {
  void postTurma() async {
    if (_formKey!.currentState!.validate()) {
      final resposta = await requisicaoTurmas.postTurmas(
        name: _nomeController!.text,
        token: widget.usuarioToken,
        minAge:
            _idadeMinController!.text.isEmpty
                ? null
                : int.parse(_idadeMinController!.text),
        maxAge:
            _idadeMaxController!.text.isEmpty
                ? null
                : int.parse(_idadeMaxController!.text),
      );
      if (resposta == 201) {
        widget.recarregarTurmas;
        widget.mostrarMsg(1);
      } else {
        widget.mostrarMsg(0);
      }
      Navigator.pop(context);
    }
  }

  selecionarIdade(int idadeMin, int tipo) {
    return showModalBottomSheet(
      // isDismissible: false,
      enableDrag: false,
      backgroundColor: Color(0xFFececec),
      context: context,
      builder: (context) {
        return Container(
          height: 390,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListaIdade(
                  idadeMin: idadeMin,
                  idadeAtual:
                      tipo == 0 ? idadeMinEscolhida! : idadeMaxEscolhida!,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    if (tipo == 0) {
                      _idadeMinController!.text =
                          idadeMinEscolhida!.value.toString();
                    } else {
                      _idadeMaxController!.text =
                          idadeMaxEscolhida!.value.toString();
                    }
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
                  child: Text(
                    'Escolher',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //controllers do form
    _formKey = GlobalKey<FormState>();
    _nomeController = TextEditingController();
    _idadeMaxController = TextEditingController();
    _idadeMinController = TextEditingController();

    //variaveis da idade
    idadeMaxEscolhida = ValueNotifier<int>(0);
    idadeMinEscolhida = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nomeController?.dispose();
    _idadeMaxController?.dispose();
    _idadeMinController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Cadastro Turma',
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Text(
                'Nome da turma: ',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(181, 0, 0, 0),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  filled: true,
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
                      color: Theme.of(context).buttonTheme.colorScheme!.primary,
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
                      color: Theme.of(context).buttonTheme.colorScheme!.primary,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  label: Text(
                    'Nome da Turma',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O nome deve ter mais de 3 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              Text(
                'Idade Mínima ',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(181, 0, 0, 0),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                readOnly: true,
                onTap: () {
                  selecionarIdade(0, 0);
                },
                controller: _idadeMinController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
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
                      color: Theme.of(context).buttonTheme.colorScheme!.primary,
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
                      color: Theme.of(context).buttonTheme.colorScheme!.primary,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  label: Text(
                    'Idade minima',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Idade Inválida';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              Text(
                'Idade Maxima ',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(181, 0, 0, 0),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                readOnly: true,
                onTap: () {
                  selecionarIdade(int.parse(_idadeMinController!.text) + 1, 1);
                },
                controller: _idadeMaxController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
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
                      color: Theme.of(context).buttonTheme.colorScheme!.primary,
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
                      color: Theme.of(context).buttonTheme.colorScheme!.primary,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  label: Text(
                    'Idade Máxima',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Idade Inválida';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        Align(
          alignment: Alignment.center,
          child: ElevatedButton.icon(
            icon: Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () {
              postTurma();
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
              backgroundColor: Color(0xFF1565C0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            label: Text(
              'Cadastrar',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
