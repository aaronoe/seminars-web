import 'package:matchings/model/seminar.dart';

class Student {
  final String name;
  final String id;
  final List<Seminar> preferences;

  Student({this.name, this.id, this.preferences});

  factory Student.fromJson(Map<String, dynamic> json) {
    final seminars = (json['preferences'] as List<dynamic>)
        .map((data) => Seminar.fromJson(data))
        .toList();

    return Student(
        id: json['id'] as String,
        name: json['name'] as String,
        preferences: seminars);
  }
}
