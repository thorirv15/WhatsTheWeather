import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import './forcasts.dart';

class ForcastListManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForcastListManagerState();
  }
}

class _ForcastListManagerState extends State<ForcastListManager> {
  final List<String> _forcasts = ['First day', 'Second day'];
  String _inputValue = '';

  void onPressed() {
    // When the button is pressed,
    // the API should be called to fetch data.
    print('the input text is: $_inputValue');
  }

  // State of the widget is set when text
  // is changed in the textfield.
  void onChanged(String inputValue) {
    setState(() {
      _inputValue = inputValue;
    });
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(35.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), 
                      labelText: 'Enter a city'),
                      onChanged: (String value) {onChanged(value);},
                ),
              ),
              RaisedButton(
                child: Text('Find'),
                onPressed: () { onPressed(); },
              ),
              Forcasts(_forcasts)
            ],
          ),
        );
      },
    );
  }
}
