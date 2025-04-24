import 'package:intl/intl.dart';

class Membro {
  
  String id;
  String nome;
  String dataDeNascimento;
  String sexo;

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
