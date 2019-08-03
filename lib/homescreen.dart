import 'package:flutter_web/material.dart';
import 'package:matchings/scoped_models/app_model.dart';
import 'package:matchings/select_data_dialog.dart';
import 'package:matchings/seminar_screen.dart';
import 'package:matchings/students_screen.dart';
import 'package:matchings/util/scoped_model.dart';

import 'matching_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CurrentScreen selectedScreen = CurrentScreen.Matchings;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: buildDrawer(context),
        appBar: AppBar(
          title: Text(_getScreenName(selectedScreen)),
        ),
        body: Padding(padding: EdgeInsets.all(16.0), child: getCurrentScreen()),
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            selected: selectedScreen == CurrentScreen.Matchings,
            leading: Icon(Icons.view_list),
            title: Text('Matchings'),
            onTap: () {
              setState(() {
                selectedScreen = CurrentScreen.Matchings;
              });
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            selected: selectedScreen == CurrentScreen.Students,
            leading: Icon(Icons.school),
            title: Text('Students'),
            onTap: () {
              setState(() {
                selectedScreen = CurrentScreen.Students;
              });
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            selected: selectedScreen == CurrentScreen.Seminars,
            leading: Icon(Icons.class_),
            title: Text('Seminars'),
            onTap: () {
              setState(() {
                selectedScreen = CurrentScreen.Seminars;
              });
              Navigator.of(context).pop();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
                width: double.infinity,
                height: 1.0,
                color: Theme.of(context).dividerColor),
          ),
          ListTile(
            leading: Icon(Icons.file_upload),
            title: Text('Import Data'),
            onTap: () async {
              //model.selectFile();
              await showDialog(
                  context: context,
                  builder: (context) {
                    return SelectDataDialog();
                  });
            },
          ),
          ScopedModelDescendant<AppModel>(
            builder: (BuildContext context, Widget child, AppModel model) {
              return ListTile(
                leading: Icon(Icons.file_download),
                title: Text('Download Data'),
                onTap: () async {
                  await model.downloadData();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget getCurrentScreen() {
    switch (selectedScreen) {
      case CurrentScreen.Students:
        return StudentsScreen();
      case CurrentScreen.Seminars:
        return SeminarScreen();
      case CurrentScreen.Matchings:
        return MatchingScreen();
    }
    return Container();
  }
}

enum CurrentScreen { Students, Seminars, Matchings }

String _getScreenName(CurrentScreen screen) {
  switch (screen) {
    case CurrentScreen.Students:
      return "Edit Students";
    case CurrentScreen.Seminars:
      return "Edit Seminars";
    case CurrentScreen.Matchings:
      return "Compute Matchings";
  }
  return null;
}
