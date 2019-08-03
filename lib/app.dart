import 'package:flutter_web/material.dart';
import 'package:matchings/scoped_models/app_model.dart';
import 'package:matchings/util/scoped_model.dart';

import 'homescreen.dart';
import 'new_student_form.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: AppModel(),
      child: MaterialApp(
        title: 'Seminar Matching System',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ScopedModelDescendant<AppModel>(
          builder: (BuildContext context, Widget child, AppModel model) {
            if (model.connectionState == SocketState.Loading) {
              return new AppLoadingWidget();
            } else if (model.appMode == null) {
              return new ModeSelectionWidget();
            } else {
              return HomePage();
            }
          },
        ),
      ),
    );
  }
}

class ModeSelectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
          return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            RaisedButton.icon(
              icon: Icon(Icons.person),
              label: Text("Proceed as Student"),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return NewStudentForm();
                    });
              },
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("OR"),
            ),
            RaisedButton.icon(
              icon: Icon(Icons.lock),
              label: Text("Proceed as Admin"),
              onPressed: () => model.setAppMode(AppMode.Admin),
            )
          ]));
        },
      ),
    );
  }
}

class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Container(
          height: 16.0,
        ),
        Text("Connecting to server. Please wait.")
      ],
    )));
  }
}
