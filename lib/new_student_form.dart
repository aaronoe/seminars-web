import 'dart:math';

import 'package:flutter_web/material.dart';
import 'package:matchings/scoped_models/app_model.dart';
import 'package:matchings/util/scoped_model.dart';

import 'model/seminar.dart';
import 'model/student.dart';

class NewStudentForm extends StatefulWidget {
  final Mode mode;
  final Student existingStudent;

  const NewStudentForm({Key key, this.mode = Mode.CREATE, this.existingStudent})
      : super(key: key);

  @override
  _NewStudentFormState createState() =>
      _NewStudentFormState(existingStudent: existingStudent);
}

enum Mode { CREATE, EDIT }

class _NewStudentFormState extends State<NewStudentForm> {
  final _priorities = List<Seminar>();
  String name = "";
  TextEditingController controller;

  _NewStudentFormState({Key key, Student existingStudent}) {
    if (existingStudent != null) {
      this.name = existingStudent.name;
      if (existingStudent.preferences != null &&
          existingStudent.preferences.isNotEmpty) {
        _priorities.addAll(existingStudent.preferences);
      }
    }
    controller = TextEditingController(text: name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Center(
        child: SizedBox(
          width: max(MediaQuery.of(context).size.width / 4, 300),
          child: ScopedModelDescendant<AppModel>(
            builder: (BuildContext context, Widget child, AppModel model) {
              return getFormBody(model, context);
            },
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        widget.mode == Mode.CREATE
            ? Container()
            : ScopedModelDescendant<AppModel>(
                builder: (BuildContext context, Widget child, AppModel model) {
                  return FlatButton(
                      onPressed: () async {
                        await model.deleteStudent(widget.existingStudent);
                        Navigator.of(context).pop();
                      },
                      child: Text("Delete"));
                },
              ),
        Container(width: 8.0),
        ScopedModelDescendant<AppModel>(
          builder: (BuildContext context, Widget child, AppModel model) {
            return FlatButton(
              onPressed: name.isEmpty
                  ? null
                  : () async {
                      if (widget.mode == Mode.CREATE) {
                        await model.createStudent(name, _priorities);
                      } else if (widget.mode == Mode.EDIT) {
                        await model.updateStudent(Student(
                            name: name,
                            id: widget.existingStudent.id,
                            preferences: _priorities));
                      }
                      Navigator.of(context).pop();
                    },
              child: Text('Save'),
            );
          },
        ),
      ],
    );
  }

  Widget getFormBody(AppModel model, BuildContext context) {
    return ListView(
      children: <Widget>[
        TextField(
          controller: controller,
          onChanged: (value) {
            setState(() {
              name = value;
            });
          },
          autofocus: true,
          decoration:
              InputDecoration(labelText: 'Student name', hintText: 'eg. Bob'),
        ),
        Container(height: 16.0),
        model.seminars.isEmpty
            ? Container()
            : Column(
                children: model.seminars
                    .where((sem) =>
                        !_priorities.any((other) => other.id == sem.id))
                    .map((seminar) => getSeminarItemWidget(
                        seminar, () => _priorities.add(seminar), "Add", -1))
                    .toList()
                      ..insert(
                          0,
                          model.seminars.length == _priorities.length
                              ? Container()
                              : Text("Available Seminars:"))),
        Container(height: 16.0),
        Column(
            children: _priorities
                .map((sem) => getSeminarItemWidget(
                    sem,
                    () => _priorities.remove(sem),
                    "Remove",
                    _priorities.indexOf(sem)))
                .toList()
                  ..insert(
                      0,
                      _priorities.isEmpty
                          ? Container()
                          : Text("Selected Seminars:"))),
      ],
    );
  }

  Widget getSeminarItemWidget(
      Seminar seminar, VoidCallback onClick, String buttonText, int index) {
    return Row(
      children: <Widget>[
        buttonText == "Remove"
            ? Expanded(child: Text("#${index + 1}"), flex: 1)
            : Container(),
        Expanded(flex: 5, child: Text(seminar.name)),
        RaisedButton(
            onPressed: () {
              setState(() {
                onClick();
              });
            },
            child: Text(buttonText))
      ],
    );
  }
}
