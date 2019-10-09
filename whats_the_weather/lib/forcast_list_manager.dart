import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';

import './forcasts.dart';

class ForcastListManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForcastListManagerState();
  }
}

class _ForcastListManagerState extends State<ForcastListManager> {
  final List<String> _forcasts = ['First day', 'Second day'];
  //final String _baseAPIurl = '';
  String _inputCityValue = '', _inputCoordinatesValues = '';

  // Location variables.
  var _location = Location();
  Map<String, double> userLocation;

  @override
  void initState() {
    super.initState();
    this._getLocation();
  }

  void onPressed(String type) {
    // When the button is pressed,
    // the API should be called to fetch data.
    if(type == 'city') {
      print('the inputCityValue is: $_inputCityValue');
    }
    else if(type == 'coordinates') {
      print('the coordinatesValues are: $_inputCoordinatesValues');
    }
  }

  // State of the widget is set when text
  // is changed in the textfield.
  void onChanged(String type, String inputValue) {
    setState(() {
      if(type == 'city') {
        _inputCityValue = inputValue;
      }
      else if(type == 'coordinates') {
        _inputCoordinatesValues = inputValue;
      }
    });
  }

  // For using current location.
  Future<Map<String, double>> _getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = await _location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
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
                      onChanged: (String value) {onChanged('city', value);},
                ),
              ),
              RaisedButton(
                child: Text('Find'),
                onPressed: () { onPressed('city'); },
              ),
              Container(
                padding: EdgeInsets.all(35.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), 
                      labelText: 'Enter coordinates'),
                      onChanged: (String value) {onChanged('coordinates', value);},
                ),
              ),
              RaisedButton(
                child: Text('Find'),
                onPressed: () { onPressed('coordinates'); },
              ),
              Forcasts(_forcasts)
            ],
          ),
        );
      },
    );
  }
}
