class TurmaTrimestre {
  String id;
  String nome;
  String turmaId;
  String trimestreId;
  int qtdProfessores;
  int registros;
  TurmaTrimestre({required this.id, required this.nome, required this.turmaId, required this.trimestreId, required this.qtdProfessores, required this.registros});
  factory TurmaTrimestre.fromMap(Map<String, dynamic> map){
    return TurmaTrimestre(
      id: map['id'], 
      nome: map['name'], 
      turmaId: map['roomId'], 
      trimestreId: map['trimesterId'], 
      qtdProfessores: map['teachers'], 
      registros: map['registrations']
    );
  }
}
//  {
//       "id": "f2c0142f-4a95-4a9f-811e-2d60ac0e8e68",
//       "name": "Adultos",
//       "roomId": "de3decc6-c418-447e-9096-f042c3a42e12",
//       "trimesterId": "c5949204-73e6-464d-91f5-40da0e32e627",
//       "registrations": 0,
//       "teachers": 0
//     }