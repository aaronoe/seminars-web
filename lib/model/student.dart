class Student {
  final String name;
  final String id;

  Student({this.name, this.id});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
