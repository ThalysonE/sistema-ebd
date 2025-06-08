import 'package:intl/intl.dart';

class Membro {
  
  String id;
  String nome;
  String dataDeNascimento;
  String sexo;
  String idUsuario = ""; //to usando pra guardar o id do usuario desse membro pra quando precisar
  bool selectBox = false;
  Membro({
    this.id ='',
    required this.nome,
    required this.dataDeNascimento,
    required this.sexo
  });

  factory Membro.fromMap(Map<String, dynamic> map) {
    return Membro(
      id: map['memberId'],
      nome: map["name"],
      dataDeNascimento:DateFormat('dd/MM/yyyy').format(DateTime.parse(map["birthDate"])),
      sexo: map["sex"]
    );
  }
}
