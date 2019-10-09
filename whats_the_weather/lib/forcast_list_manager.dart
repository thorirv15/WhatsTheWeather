import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


import './forcasts.dart';

class ForcastListManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForcastListManagerState();
  }
}

class _ForcastListManagerState extends State<ForcastListManager> {
  final String _weatherAPIKey = '&appid=714eba573f46406d2d6e1d6da46538cf';
  final String _baseAPIurl = 'http://api.openweathermap.org/data/2.5/forecast?';
  String _inputCityValue = '', _inputCoordinatesValues = '';
  List _weatherData = [];
  String _city = '', _country = '';

  @override
  void initState() {
    super.initState();
  }

  void onPressed(String searchType) {
    // When the button is pressed,
    // the API should be called to fetch data.
    String queryString = '';
    if(searchType == 'city') {
      queryString = 'q=' + _inputCityValue;
    }
    else if(searchType == 'coordinates') {
      var splitted = _inputCoordinatesValues.split(",");
      queryString = 'lat=' + splitted[0] + '&lon=' + splitted[1];    
    }

    fetchWeatherData(queryString);
    
  }

  // State of the widget is set when text
  // is changed in the textfield.
  void onChanged(String searchType, String inputValue) {
    setState(() {
      if(searchType == 'city') {
        _inputCityValue = inputValue;
      }
      else if(searchType == 'coordinates') {
        _inputCoordinatesValues = inputValue;
      }
    });
  }

  Future fetchWeatherData(String queryParams) async {
    print(_baseAPIurl);
    String url = _baseAPIurl + queryParams + _weatherAPIKey;
    print(url);
    var res = await http.get(
      Uri.encodeFull(url),
      headers: {"Accept": "application/json"}
    );

    if(res.statusCode == 200) {
        setState(() {
          var extractData = json.decode(res.body);
          _weatherData = extractData["list"];
          _city = extractData["city"]["name"];
          _country = extractData["city"]["country"];
      });
    }
    else {
      setState(() {
        _weatherData = [];
        _city = "";
        _country = "";
      });
    }

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
                      onChanged: (String value) {onChanged('city', value);}
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
                      labelText: 'Enter coordinates: Lat, Long'),
                      onChanged: (String value) {onChanged('coordinates', value);},
                ),
              ),
              RaisedButton(
                child: Text('Find'),
                onPressed: () { onPressed('coordinates'); },
              ),
              Text(_city),
              Text(_country),
              Forcasts(_weatherData)
            ],
          ),
        );
      },
    );
  }
}
