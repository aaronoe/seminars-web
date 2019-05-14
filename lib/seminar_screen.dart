import 'package:flutter_web/material.dart';
import 'package:matchings/scoped_models/app_model.dart';
import 'package:matchings/util/scoped_model.dart';

import 'model/seminar.dart';

class SeminarScreen extends StatelessWidget {
  Future _showSeminarDialog(BuildContext context) async {
    String title = '';
    int capacity = 0;

    return showDialog(
      context: context,
      barrierDismissible:
          true, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create new seminar'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: 'Seminar title',
                      hintText: 'eg. Graphalgorithms'),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    onChanged: (value) {
                      capacity = int.parse(value);
                    },
                    decoration: InputDecoration(
                        labelText: "Capacity", hintText: "eg. 12"))
              ],
            ),
          ),
          actions: <Widget>[
            ScopedModelDescendant<AppModel>(
              builder: (BuildContext context, Widget child, AppModel model) {
                return FlatButton(
                  child: Text('Save'),
                  onPressed: () async {
                    await model.createSeminar(title, capacity);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
      if (model.seminars.isEmpty) {
        return buildNewSeminarCard(context);
      } else {
        return GridView.count(
          childAspectRatio: 3,
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
            trailing: ScopedModelDescendant<AppModel>(
              builder: (BuildContext context, Widget child, AppModel model) {
                return FlatButton(
                    color: Theme.of(context).buttonColor,
                    onPressed: () async => await model.deleteSeminar(seminar),
                    child: Text("Delete"));
              },
            )),
      ),
    );
  }
}
