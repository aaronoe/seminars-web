import 'package:flutter_web/material.dart';
import 'package:matchings/scoped_models/app_model.dart';
import 'package:matchings/seminar_screen.dart';
import 'package:matchings/students_screen.dart';
import 'package:matchings/util/scoped_model.dart';

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Alert Dialog title"),
        content: new Text("Alert Dialog body"),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showDialog(context);
          },
          child: Icon(Icons.ac_unit),
        ),
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text("Edit Students"),
              ),
              Tab(child: Text("Edit Seminars")),
              Tab(child: Text("Run & Results"))
            ],
          ),
          title: Text("Seminar Matchings"),
        ),
        body: ScopedModelDescendant<AppModel>(
          builder: (BuildContext context, Widget child, AppModel model) {
            return TabBarView(
              children: <Widget>[
                StudentsScreen(),
                SeminarScreen(),
                Text("Three"),
              ],
            );
          },
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
