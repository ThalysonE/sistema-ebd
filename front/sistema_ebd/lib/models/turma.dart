import 'package:flutter/foundation.dart';

class Turma {
  String name;
  int? minAge;
  int? maxAge;
  bool? selectBox = false;
  Turma({required this.name, this.minAge, this.maxAge});
  
  factory Turma.fromMap(Map<String, dynamic> map){
    return Turma(
      name: map['name'],
      minAge: map['minAge'],
      maxAge: map['maxAge']
    );
  }
  
}
