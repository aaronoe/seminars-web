import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:matchings/model/matching.dart';
import 'package:matchings/model/seminar.dart';
import 'package:matchings/model/socket_data.dart';
import 'package:matchings/model/student.dart';
import 'package:matchings/util/scoped_model.dart';

class AppModel extends Model {
  static final BASE_URL = "http://127.0.0.1:8000";
  final _client = http.Client();

  List<Student> _students = [];
  List<Seminar> _seminars = [];
  List<Matching> _matchings = [];

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
  List<Matching> get matchings => _matchings;

  Future getMatching() async {
    final response = await _client.get("$BASE_URL/match");
    final parsed = json.decode(response.body);

    _matchings = Matching.parseResponse(parsed);
    print(_matchings);
    notifyListeners();
  }

  Future downloadData() async {
    window.location.assign("$BASE_URL/download");
  }

  Future deleteStudent(Student student) async {
    return await _client.delete("$BASE_URL/students/${student.id}",
        headers: {"Origin": "test"});
  }

  Future deleteSeminar(Seminar seminar) async {
    return await _client.delete("$BASE_URL/seminars/${seminar.id}",
        headers: {"Origin": "test"});
  }

  Future<http.Response> postData(String url, Map<String, dynamic> body) async {
    return _client.post(url,
        body: json.encode(body),
        headers: {"Content-Type": "application/json"},
        encoding: Encoding.getByName("application/json"));
  }

  Future createSeminar(String name, int capacity) async {
    await postData(
        "$BASE_URL/seminars", {'name': name, 'capacity': capacity.toString()});
  }

  Future createStudent(String name, List<Seminar> priorities) async {
    await postData("$BASE_URL/students", {
      'name': name,
      'preferences': priorities.map((seminar) => seminar.toJson()).toList()
    });
  }
}
