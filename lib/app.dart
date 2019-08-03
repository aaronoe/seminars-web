import 'package:flutter_web/material.dart';
import 'package:matchings/scoped_models/app_model.dart';
import 'package:matchings/util/scoped_model.dart';

import 'homescreen.dart';

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
            } else {
              return HomePage();
            }
          },
        ),
      ),
    );
  }
}
