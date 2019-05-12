import 'package:matchings/model/seminar.dart';
import 'package:matchings/model/student.dart';

class SocketData {
  final List<Student> students;
  final List<Seminar> seminars;

  SocketData({this.students, this.seminars});

  factory SocketData.fromJson(Map<String, dynamic> json) {
    final students = (json['students'] as List<dynamic>)
        .map((data) => Student.fromJson(data))
        .toList();

    final seminars = (json['seminars'] as List<dynamic>)
        .map((data) => Seminar.fromJson(data))
        .toList();

    return SocketData(
      students: students,
      seminars: seminars,
    );
  }
}
