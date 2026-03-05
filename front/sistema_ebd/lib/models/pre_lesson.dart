class PreLesson {
  String id;
  String trimesterId;
  int lesson;
  DateTime date;
  int pendingClasses;
  DateTime createdAt;

  PreLesson({
    required this.id,
    required this.trimesterId,
    required this.lesson,
    required this.date,
    required this.pendingClasses,
    required this.createdAt,
  });

  factory PreLesson.fromMap(Map<String, dynamic> map) {
    return PreLesson(
      id: map['prelessonId'] ?? map['id'] ?? '',
      trimesterId: map['trimesterId'] ?? '',
      lesson: map['lesson'] ?? 0,
      date: DateTime.parse(map['date']),
      pendingClasses: map['pendingClasses'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
