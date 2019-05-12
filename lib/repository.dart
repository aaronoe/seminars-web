import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:matchings/model/socket_data.dart';

class Repository {
  Stream<SocketData> _socketStream;
  static final Repository _repository = Repository._internal();

  Repository._internal() {
    var socket = WebSocket('ws://127.0.0.1:8000/').onMessage;
    var stream = StreamController.broadcast()..addStream(socket);

    _socketStream = stream.stream
        .asBroadcastStream()
        .map((item) => SocketData.fromJson(json.decode(item)))
          ..forEach((data) => _cachedData = data);
  }

  factory Repository() => _repository;

  static SocketData _cachedData;
  final BASE_URL = "https:///127.0.0.1:8000/";
  final _client = http.Client();

  Future<http.Response> postData(String url) async {
    return _client.post(url);
  }

  Stream<SocketData> get students {
    final students = StreamController<SocketData>();
    if (_cachedData != null) {
      students.add(_cachedData);
    }
    students.addStream(_socketStream);
    return students.stream;
  }

  Future createSeminar() async {
    await postData("$BASE_URL/seminars");
  }

  Future createStudent() async {
    await postData("$BASE_URL/students");
  }
}
