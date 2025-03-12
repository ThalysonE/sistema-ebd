class Membro {
  
  String nome;
  String dataDeNascimento;
  String sexo;


  Membro({
    required this.nome,
    required this.dataDeNascimento,
    required this.sexo,
  });

  factory Membro.fromMap(Map<String, dynamic> map) {
    return Membro(
      nome: map["name"],
      dataDeNascimento: map["birthDate"],
      sexo: map["sex"],
    );
  }
}
