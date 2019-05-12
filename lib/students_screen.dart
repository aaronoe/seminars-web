import 'package:flutter_web/material.dart';

class StudentsScreen extends StatefulWidget {
  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<String> _students = ["Test", "Hallo"];

  void _addStudent(String name) {
    setState(() {
      _students.add(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 4,
        children: _students.map((name) {
          return ListTile(trailing: Text("Edit"), title: Text(name));
        }).toList());
  }
}
