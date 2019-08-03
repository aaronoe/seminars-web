import 'dart:html';

import 'package:flutter_web/material.dart';
import 'package:matchings/scoped_models/app_model.dart';
import 'package:matchings/util/scoped_model.dart';

class SelectDataDialog extends StatefulWidget {
  @override
  _SelectDataDialogState createState() => _SelectDataDialogState();
}

class _SelectDataDialogState extends State<SelectDataDialog> {
  Dataset _dataset = Dataset.PrefLib1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Dataset"),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel")),
        ScopedModelDescendant<AppModel>(
          builder: (BuildContext context, Widget child, AppModel model) {
            return FlatButton(
                onPressed: () => applyChanges(model), child: Text("Save"));
          },
        )
      ],
      content: ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile(
                  title: Text("PrefLib1"),
                  value: Dataset.PrefLib1,
                  groupValue: _dataset,
                  onChanged: onDatasetChanged),
              RadioListTile(
                  title: Text("PrefLib2"),
                  value: Dataset.PrefLib2,
                  groupValue: _dataset,
                  onChanged: onDatasetChanged),
              RadioListTile(
                  title: Text("Zipfian"),
                  value: Dataset.Zipfian,
                  groupValue: _dataset,
                  onChanged: onDatasetChanged),
              RadioListTile(
                  title: Text("Uniform"),
                  value: Dataset.Uniform,
                  groupValue: _dataset,
                  onChanged: onDatasetChanged),
              RadioListTile(
                  title: model.selectedFile != null
                      ? Text("Custom (${model.selectedFile.name})")
                      : Text("Custom JSON File"),
                  value: Dataset.Custom,
                  groupValue: _dataset,
                  onChanged: (dataset) async {
                    File file = await model.pickFile();

                    if (file != null) {
                      onDatasetChanged(dataset);
                    }
                  }),
            ],
          );
        },
      ),
    );
  }

  void onDatasetChanged(Dataset dataset) {
    setState(() {
      _dataset = dataset;
    });
  }

  void applyChanges(AppModel model) {
    if (_dataset == Dataset.Custom) {
      model.uploadFile(model.selectedFile);
    } else {
      model.changeDataset(_dataset);
    }

    Navigator.of(context).pop();
  }
}

enum Dataset { PrefLib1, PrefLib2, Zipfian, Uniform, Custom }
