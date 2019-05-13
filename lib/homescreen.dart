import 'package:flutter_web/material.dart';
import 'package:matchings/scoped_models/app_model.dart';
import 'package:matchings/seminar_screen.dart';
import 'package:matchings/students_screen.dart';
import 'package:matchings/util/scoped_model.dart';

import 'seminars/new_seminar_form.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                NewSeminarForm(),
              ],
            );
          },
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
