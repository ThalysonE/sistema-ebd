class Membro {
  
  String nome;
  String dataDeNascimento;
  String sexo;
  int idade;

  Membro({
    required this.nome,
    required this.dataDeNascimento,
    required this.sexo,
    required this.idade,
  });

  factory Membro.fromMap(Map<String, dynamic> map) {
    return Membro(
      nome: map["name"],
      dataDeNascimento: map["birthDate"],
      sexo: map["sex"],
      idade: map["age"],
    );
  }
}
