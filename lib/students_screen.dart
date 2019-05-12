import 'package:flutter_web/material.dart';
import 'package:matchings/scoped_models/app_model.dart';
import 'package:matchings/util/scoped_model.dart';

import 'model/student.dart';

class StudentsScreen extends StatefulWidget {
  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
      if (model.students.isEmpty) {
        return Center(child: Text("No students yet"));
      } else {
        print("New student length: ${model.students.length}");
        return GridView.count(
          childAspectRatio: 3,
          children: model.students
              .map((student) => StudentCard(student: student))
              .toList(),
          crossAxisCount: 8,
        );
      }
    });
  }
}

class StudentCard extends StatelessWidget {
  final Student student;

  const StudentCard({Key key, @required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(student.name),
            ScopedModelDescendant<AppModel>(
              builder: (BuildContext context, Widget child, AppModel model) {
                return FlatButton(
                    color: Theme.of(context).buttonColor,
                    onPressed: () async => await model.deleteStudent(student),
                    child: Text("Delete"));
              },
            )
          ]),
    ));
  }
}
