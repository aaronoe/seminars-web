import 'package:flutter_web/material.dart';
import 'package:matchings/scoped_models/app_model.dart';
import 'package:matchings/util/scoped_model.dart';

import 'model/seminar.dart';
import 'new_student_form.dart';

class SeminarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
      if (model.seminars.isEmpty) {
        return buildNewSeminarCard(context);
      } else {
        return GridView.count(
          childAspectRatio: 2,
          children: model.seminars
              .map<Widget>((seminar) => SeminarCard(seminar: seminar))
              .toList()
                ..insert(0, buildNewSeminarCard(context)),
          crossAxisCount: (MediaQuery.of(context).size.width / 300).floor(),
        );
      }
    });
  }

  Card buildNewSeminarCard(BuildContext context) {
    return Card(
      child: Center(
          child: RaisedButton(
              onPressed: () async {
                await _showSeminarDialog(context);
              },
              child: Text("Add new"))),
    );
  }
}

Future _showSeminarDialog(BuildContext context,
    {Mode mode = Mode.CREATE, Seminar existingSeminar}) async {
  String title = existingSeminar != null ? existingSeminar.name : '';
  int capacity = existingSeminar != null ? existingSeminar.capacity : 0;
  TextEditingController titleController = TextEditingController(text: title);
  TextEditingController capacityController =
      TextEditingController(text: capacity != 0 ? capacity.toString() : null);

  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Create new seminar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'Seminar title', hintText: 'eg. Graphalgorithms'),
              onChanged: (value) {
                title = value;
              },
              controller: titleController,
            ),
            TextField(
                controller: capacityController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  capacity = int.parse(value);
                },
                decoration:
                    InputDecoration(labelText: "Capacity", hintText: "eg. 12"))
          ],
        ),
        actions: <Widget>[
          ScopedModelDescendant<AppModel>(
            builder: (BuildContext context, Widget child, AppModel model) {
              return Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: mode == Mode.CREATE
                        ? Container()
                        : FlatButton(
                            onPressed: () async {
                              await model.deleteSeminar(existingSeminar);
                              Navigator.of(context).pop();
                            },
                            child: Text("Delete")),
                  ),
                  FlatButton(
                    child: Text('Save'),
                    onPressed: () async {
                      if (title.isEmpty) return;
                      if (mode == Mode.CREATE) {
                        model.createSeminar(title, capacity);
                      } else if (mode == Mode.EDIT) {
                        model.updateSeminar(Seminar(
                            id: existingSeminar.id,
                            name: title,
                            capacity: capacity));
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ),
        ],
      );
    },
  );
}

class SeminarCard extends StatelessWidget {
  final Seminar seminar;

  const SeminarCard({Key key, @required this.seminar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: ListTile(
            title: Text(seminar.name),
            subtitle: Text("Capacity: ${seminar.capacity}"),
            trailing: RaisedButton(
                onPressed: () async {
                  await _showSeminarDialog(context,
                      mode: Mode.EDIT, existingSeminar: seminar);
                },
                child: Text("Edit"))),
      ),
    );
  }
}
