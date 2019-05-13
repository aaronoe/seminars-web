import 'package:flutter_web/material.dart';
import 'package:matchings/scoped_models/app_model.dart';
import 'package:matchings/util/scoped_model.dart';

import 'model/seminar.dart';

class NewStudentForm extends StatefulWidget {
  @override
  _NewStudentFormState createState() => _NewStudentFormState();
}

class _NewStudentFormState extends State<NewStudentForm> {
  final _priorities = List<Seminar>();
  String _name = "";

  _NewStudentFormState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ScopedModelDescendant<AppModel>(
                builder: (BuildContext context, Widget child, AppModel model) {
                  return getFormBody(model, context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column getFormBody(AppModel model, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          onChanged: (value) {
            _name = value;
          },
          autofocus: true,
          decoration:
              InputDecoration(labelText: 'Student name', hintText: 'eg. Bob'),
        ),
        Container(height: 16.0),
        Column(
            children: _priorities
                .map((sem) =>
                    SeminarItem(sem, () => _priorities.remove(sem), "Remove"))
                .toList()
                  ..insert(
                      0,
                      _priorities.isEmpty
                          ? Container()
                          : Text("Selected Seminars:"))),
        Container(height: 16.0),
        model.seminars.isEmpty
            ? Container()
            : Column(
                children: model.seminars
                    .where((sem) => !_priorities.contains(sem))
                    .map((seminar) => SeminarItem(
                        seminar, () => _priorities.add(seminar), "Add"))
                    .toList()
                      ..insert(
                          0,
                          model.seminars.length == _priorities.length
                              ? Container()
                              : Text("Available Seminars:"))),
        RaisedButton(
          onPressed: () async {
            await model.createStudent(_name, _priorities);
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        )
      ],
    );
  }

  Widget SeminarItem(Seminar seminar, VoidCallback onClick, String buttonText) {
    return Row(
      children: <Widget>[
        Expanded(flex: 3, child: Text(seminar.name)),
        Expanded(
          flex: 1,
          child: RaisedButton(
              onPressed: () {
                setState(() {
                  onClick();
                });
              },
              child: Text(buttonText)),
        )
      ],
    );
  }
}
