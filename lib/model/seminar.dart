class Seminar {
  final String id;
  final String name;
  final int capacity;

  Seminar({this.id, this.name, this.capacity});

  factory Seminar.fromJson(Map<String, dynamic> json) {
    return Seminar(
        id: json['id'] as String,
        name: json['name'] as String,
        capacity: json['capacity'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'capacity': capacity, 'id': id};
  }
}
