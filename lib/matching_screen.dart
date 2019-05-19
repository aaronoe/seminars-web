import 'package:flutter_web/material.dart';
import 'package:matchings/scoped_models/app_model.dart';
import 'package:matchings/util/scoped_model.dart';

import 'model/matching.dart';

class MatchingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        if (model.matchData == null || model.matchData.matchings.isEmpty) {
          return _buildComputeButton(model);
        } else {
          return GridView.count(
            children: model.matchData.matchings
                .map<Widget>((matching) => MatchingCard(matching: matching))
                .toList()
                  ..insert(0, _buildResultButton(model)),
            crossAxisCount: (MediaQuery.of(context).size.width / 300).floor(),
          );
        }
      },
    );
  }

  Widget _buildResultButton(AppModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Profile ${model.matchData.profile}"),
        Container(height: 4.0),
        Text("Unassigned Student Count: ${model.matchData.unassignedCount}"),
        Container(height: 16.0),
        RaisedButton(
            child: Text("Compute Matching"),
            onPressed: () async {
              await model.getMatching();
            }),
      ],
    );
  }

  Widget _buildComputeButton(AppModel model) {
    return Center(
      child: RaisedButton(
          child: Text("Compute Matching"),
          onPressed: () async {
            await model.getMatching();
          }),
    );
  }
}

class MatchingCard extends StatelessWidget {
  final Matching matching;

  const MatchingCard({Key key, @required this.matching}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      matching.seminar.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16.0),
                    ),
                  ),
                  Divider(),
                ] +
                matching.students
                    .map<Widget>((student) => Text(student.name))
                    .toList()),
      ),
    );
  }
}
