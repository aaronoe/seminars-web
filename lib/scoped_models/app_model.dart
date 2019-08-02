import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:matchings/model/match_data.dart';
import 'package:matchings/model/seminar.dart';
import 'package:matchings/model/socket_data.dart';
import 'package:matchings/model/student.dart';
import 'package:matchings/util/scoped_model.dart';

class AppModel extends Model {
  static final _BASE_HOST_LOCAL = "0.0.0.0:8000";
  static final _BASE_HOST = "seminar-matching.herokuapp.com/";
  static final BASE_URL = "http://$_BASE_HOST_LOCAL";
  final _client = http.Client();

  List<Student> _students = [];
  List<Seminar> _seminars = [];
  MatchData _matchData;

  AppModel() {
    WebSocket('ws://$_BASE_HOST_LOCAL/')
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
  MatchData get matchData => _matchData;

  Future getMatching(String algorithm) async {
    final response = await _client.get("$BASE_URL/match/$algorithm");
    final parsed = json.decode(response.body);

    print(parsed);
    _matchData = MatchData.fromJson(parsed);
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

  Future updateSeminar(Seminar toUpdate) async {
    await postData("$BASE_URL/seminars/${toUpdate.id}",
        {'name': toUpdate.name, 'capacity': toUpdate.capacity.toString()});
  }

  Future updateStudent(Student toUpdate) async {
    await postData("$BASE_URL/students/${toUpdate.id}", {
      'name': toUpdate.name,
      'preferences':
          toUpdate.preferences.map((seminar) => seminar.toJson()).toList()
    });
  }

  Future createStudent(String name, List<Seminar> priorities) async {
    await postData("$BASE_URL/students", {
      'name': name,
      'preferences': priorities.map((seminar) => seminar.toJson()).toList()
    });
  }
}
