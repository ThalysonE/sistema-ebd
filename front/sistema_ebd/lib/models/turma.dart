class Turma {
  String id;
  String name;
  int? minAge;
  int? maxAge;
  bool? selectBox = false;
  Turma({required this.id, required this.name, this.minAge, this.maxAge});
  
  factory Turma.fromMap(Map<String, dynamic> map){
    return Turma(
      id: map['id'],
      name: map['name'],
      minAge: map['minAge'],
      maxAge: map['maxAge']
    );
  }
  
}
