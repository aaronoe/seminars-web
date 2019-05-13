import 'package:flutter_web/material.dart';

class NewSeminarForm extends StatefulWidget {
  @override
  _NewSeminarFormState createState() => _NewSeminarFormState();
}

class _NewSeminarFormState extends State<NewSeminarForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(labelText: "Seminar Title"),
        validator: (value) {
          if (value.isEmpty) {
            return "Please enter a title";
          }
        },
      ),
      TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            labelText: "Capacity",
          ))
    ]));
  }
}
