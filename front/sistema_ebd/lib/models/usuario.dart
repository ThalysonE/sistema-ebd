class Usuario{
  String id;
  String email;
  String role;
  String userName;
  bool isMember;
  String memberId;
  bool selectBox = false; //usado para gerenciar o estado do item em com um checkbox
  Usuario({required this.id, required this.role, required this.userName, required this.isMember, required this.memberId, required this.email});

  factory Usuario.fromMap(Map<String, dynamic> map){
    return Usuario(id: map['id'], email: map['email'], role: map['role'], userName: map['username'], isMember: map['isMember'], memberId: map['memberId']);
  }
}