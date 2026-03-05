class Lesson {
  String id;
  String trimesterRoomId;
  String preLessonId;
  String title;
  int visitors;
  int bibles;
  int magazines;
  double offers;
  DateTime createdAt;
  DateTime? updatedAt;

  Lesson({
    required this.id,
    required this.trimesterRoomId,
    required this.preLessonId,
    required this.title,
    required this.visitors,
    required this.bibles,
    required this.magazines,
    required this.offers,
    required this.createdAt,
    this.updatedAt,
  });

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'],
      trimesterRoomId: map['trimesterRoomId'],
      preLessonId: map['preLessonId'],
      title: map['title'] ?? '',
      visitors: map['visitors'] ?? 0,
      bibles: map['bibles'] ?? 0,
      magazines: map['magazines'] ?? 0,
      offers: (map['offers'] ?? 0).toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }
}
