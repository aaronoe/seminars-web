import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:matchings/model/seminar.dart';
import 'package:matchings/model/socket_data.dart';
import 'package:matchings/model/student.dart';
import 'package:matchings/util/scoped_model.dart';

class AppModel extends Model {
  static final BASE_URL = "http://127.0.0.1:8000";
  final _client = http.Client();

  List<Student> _students = [];
  List<Seminar> _seminars = [];

  AppModel() {
    WebSocket('ws://127.0.0.1:8000/')
        .onMessage
        .map((item) => SocketData.fromJson(json.decode(item.data)))
        .listen((data) {
      print("New data: $data");
      _students = data.students;
      _seminars = data.seminars;
      notifyListeners();
    });
  }

  List<Student> get students => _students;
  List<Seminar> get seminars => _seminars;

  Future deleteStudent(Student student) async {
    return await _client.delete("$BASE_URL/students/${student.id}",
        headers: {"Origin": "test"});
  }
}
