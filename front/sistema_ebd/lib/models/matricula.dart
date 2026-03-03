class Matricula {
  String registrationId;
  String memberId;
  String name;

  Matricula({
    required this.registrationId,
    required this.memberId,
    required this.name,
  });

  factory Matricula.fromMap(Map<String, dynamic> map) {
    return Matricula(
      registrationId: map['registrationId'],
      memberId: map['memberId'],
      name: map['name'],
    );
  }
}
