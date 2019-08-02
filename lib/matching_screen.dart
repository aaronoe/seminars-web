import 'package:flutter_web/material.dart';
import 'package:matchings/scoped_models/app_model.dart';
import 'package:matchings/util/scoped_model.dart';

import 'model/matching.dart';

class MatchingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        switch (model.loadingState) {
          case MatchingLoadingState.NOT_STARTED:
            return ComputeButton();
            break;
          case MatchingLoadingState.LOADING:
            return Center(child: CircularProgressIndicator());
            break;
          case MatchingLoadingState.DONE:
            return GridView.count(
              children: model.matchData.matchings
                  .map<Widget>((matching) => MatchingCard(matching: matching))
                  .toList()
                    ..insert(0, _buildResultButton(model)),
              crossAxisCount: (MediaQuery.of(context).size.width / 300).floor(),
            );
            break;
        }

        return Container();
      },
    );
  }

  Widget _buildResultButton(AppModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Profile ${model.matchData.statistics.profile}"),
        Container(height: 4.0),
        Text(
            "Unassigned Student Count: ${model.matchData.statistics.unassignedCount}"),
        Container(height: 16.0),
        ComputeButton()
      ],
    );
  }
}

class ComputeButton extends StatefulWidget {
  @override
  _ComputeButtonState createState() => _ComputeButtonState();
}

class _ComputeButtonState extends State<ComputeButton> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<Algorithm>(
                value: model.algorithm,
                items: Algorithm.values
                    .map((item) => DropdownMenuItem(
                        child: Text(getAlgorithmName(item)), value: item))
                    .toList(),
                iconSize: 0.0,
                onChanged: (Algorithm newValue) {
                  setState(() {
                    model.setAlgorithm(newValue);
                  });
                }),
            Container(width: 8.0),
            RaisedButton(
                onPressed: () async => await model.getMatching(),
                child: Text("Find Matching"))
          ]);
    });
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
        child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
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
