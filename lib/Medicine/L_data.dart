class Medicine {
  int? id;
  final String name;
  final String dosage;
  final String type;
  final String time;

  Medicine({
    this.id,
    required this.name,
    required this.dosage,
    required this.type,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'type': type,
      'time': time,
    };
  }
}
