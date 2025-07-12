class Trimestre {
  String titulo;
  int ano;
  int numTrimestre;
  String dataInicio;
  String dataFim;

  Trimestre({required this.titulo, required this.ano, required this.numTrimestre, required this.dataInicio, required this.dataFim});
  factory Trimestre.fromMap(Map<String, dynamic> map){
    return Trimestre(
      titulo: map['title'], 
      ano: map['year'], 
      numTrimestre: map['quarter'], 
      dataInicio: map['startDate'], 
      dataFim: map['endDate']
    );
  }
//   {
//   "title": "1º Trimestre",
//   "year": 2025,
//   "quarter": 1,
//   "startDate": "2025-01-01",
//   "endDate": "2025-03-31"
// }
}