import 'package:matchings/model/seminar.dart';
import 'package:matchings/model/student.dart';

class Matching {
  final Seminar seminar;
  final List<Student> students;

  Matching({this.students, this.seminar});

  factory Matching.fromJson(Map<String, dynamic> json) {
    final students = (json['students'] as List<dynamic>)
        .map((data) => Student.fromJson(data))
        .toList();

    return Matching(
        seminar: Seminar.fromJson(json['seminar']), students: students);
  }

  static List<Matching> parseResponse(List<dynamic> json) {
    return json.map((item) => Matching.fromJson(item)).toList();
  }
}
