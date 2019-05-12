import 'package:flutter_web/material.dart';
import 'package:matchings/scoped_models/app_model.dart';
import 'package:matchings/util/scoped_model.dart';

import 'model/seminar.dart';

class SeminarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
      if (model.seminars.isEmpty) {
        return Center(child: Text("No seminars yet"));
      } else {
        return GridView.count(
          childAspectRatio: 3,
          children: model.seminars
              .map((seminar) => SeminarCard(seminar: seminar))
              .toList(),
          crossAxisCount: 8,
        );
      }
    });
  }
}

class SeminarCard extends StatelessWidget {
  final Seminar seminar;

  const SeminarCard({Key key, @required this.seminar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
