import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:matchings/model/match_data.dart';
import 'package:matchings/model/seminar.dart';
import 'package:matchings/model/socket_data.dart';
import 'package:matchings/model/student.dart';
import 'package:matchings/util/scoped_model.dart';

import '../select_data_dialog.dart';

class AppModel extends Model {
  static final _BASE_HOST_LOCAL = "0.0.0.0:8000";
  static final _BASE_HOST = "seminar-matching.herokuapp.com/";
  static final BASE_URL = "http://$_BASE_HOST_LOCAL";
  final _client = http.Client();

  List<Student> _students = [];
  List<Seminar> _seminars = [];
  MatchData _matchData;
  MatchingLoadingState _loadingState = MatchingLoadingState.NOT_STARTED;
  Algorithm _selectedAlgorithm = Algorithm.hungarian;
  File _selectedFile;

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

  void uploadFile(File file) async {
    FormData data = FormData();
    data.appendBlob("file", file);
    var request = HttpRequest();
    request.open("POST", "$BASE_URL/file");
    request.send(data);
  }

  Future<File> pickFile() async {
    InputElement input = document.createElement('input');
    input.type = 'file';

    input.click();
    dynamic event = await input.onChange.first;
    File file = event.target.files[0];
    if (file != null) {
      _selectedFile = file;
      notifyListeners();
    }

    input.remove();
    return file;
  }

  void uploadAsMultipart() {
    InputElement input = document.createElement('input');
    input.type = 'file';

    input.onChange.listen((e) {
      // read file content as dataURL
      final files = input.files;
      if (files.length == 1) {
        final file = files[0];
        final reader = new FileReader();
        reader.onLoad.listen((e) {
          var mreq =
              new http.MultipartRequest("POST", Uri.parse("$BASE_URL/upload"));
          mreq.files.add(http.MultipartFile.fromString("file", reader.result));

          mreq.send().then((response) {
            if (response.statusCode == 200) print("Uploaded!");
          });
        });
        reader.readAsDataUrl(file);
      }
    });
    input.click();
  }

  void downloadMatching() {
    var buffer = StringBuffer();

    matchData.matchings.forEach((matching) {
      buffer.writeln("${matching.seminar.name} (${matching.seminar.id}):");
      buffer.writeAll(
          matching.students.map((student) => "${student.name} (${student.id})"),
          "\n");

      buffer.writeln("\n");
    });

    _downloadFile(
        "matching_${getAlgorithmName(algorithm)}_${DateTime.now().toIso8601String()}.txt",
        buffer.toString());
  }

  void _downloadFile(String fileName, String content) {
    var element = document.createElement('a');

    element.setAttribute('href', 'data:text/plain;charset=utf-8,' + content);
    element.setAttribute('download', fileName);

    element.style.display = 'none';
    document.body.append(element);

    element.click();
    element.remove();
  }

  List<Student> get students => _students;
  List<Seminar> get seminars => _seminars;
  MatchData get matchData => _matchData;
  MatchingLoadingState get loadingState => _loadingState;
  Algorithm get algorithm => _selectedAlgorithm;
  File get selectedFile => _selectedFile;

  void setAlgorithm(Algorithm algorithm) {
    this._selectedAlgorithm = algorithm;
    notifyListeners();
  }

  Future getMatching() async {
    _loadingState = MatchingLoadingState.LOADING;
    notifyListeners();

    final response =
        await _client.get("$BASE_URL/match/${getAlgorithmName(algorithm)}");
    final parsed = json.decode(response.body);

    print(parsed);
    _matchData = MatchData.fromJson(parsed);

    _loadingState = MatchingLoadingState.DONE;
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

  Future changeDataset(Dataset dataset) async {
    await postData("$BASE_URL/dataset", {'name': _getDatasetPostName(dataset)});
  }
}

enum MatchingLoadingState { NOT_STARTED, LOADING, DONE }

enum Algorithm { hungarian, rsd, max_pareto, popular, popular_mod }

String _getDatasetPostName(Dataset dataset) {
  switch (dataset) {
    case Dataset.PrefLib1:
      return "PrefLib1";
    case Dataset.PrefLib2:
      return "PrefLib2";
    case Dataset.Zipfian:
      return "Zipfian";
    case Dataset.Uniform:
      return "Uniform";
    case Dataset.Custom:
      return "Custom";
  }

  return null;
}

String getAlgorithmName(Algorithm algorithm) {
  switch (algorithm) {
    case Algorithm.hungarian:
      return "hungarian";
    case Algorithm.rsd:
      return "rsd";
    case Algorithm.max_pareto:
      return "max-pareto";
    case Algorithm.popular:
      return "popular";
    case Algorithm.popular_mod:
      return "popular-mod";
  }

  return "hungarian";
}
