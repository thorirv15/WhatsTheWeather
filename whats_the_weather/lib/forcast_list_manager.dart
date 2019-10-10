// Package imports.
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Internal imports.
import './forcasts.dart';

class ForcastListManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForcastListManagerState();
  }
}

class _ForcastListManagerState extends State<ForcastListManager> {
  final String _weatherAPIKey =
      '936547b0cfmsh007bf695be676f6p118acejsn7e2010b5d570';
  final String _baseAPIurl =
      'https://community-open-weather-map.p.rapidapi.com/forecast';
  List _forcastData = [];
  String _inputCityValue = '', _inputCoordinatesValues = '';
  String _todayTitle = '';

  @override
  void initState() {
    super.initState();
  }

  void onPressed(String searchType) {
    // When the button is pressed,
    // the API should be called to fetch data.
    String queryString = '';
    if (searchType == 'city') {
      queryString = 'q=' + _inputCityValue;
    } else if (searchType == 'coordinates') {
      var splitted = _inputCoordinatesValues.split(",");
      queryString = 'lat=' + splitted[0] + '&lon=' + splitted[1];
    }

    fetchForcastData(queryString);
  }

  // State of the widget is set when text
  // is changed in the textfield.
  void onChanged(String searchType, String inputValue) {
    setState(() {
      if (searchType == 'city') {
        _inputCityValue = inputValue;
      } else if (searchType == 'coordinates') {
        _inputCoordinatesValues = inputValue;
      }
    });
  }

  // Construct final list to display.
  void constructFinalList(List detailedForcastData, List forcastData) {
    for (int i = 0; i < forcastData.length; i++) {
      DateTime date =
          DateTime.fromMillisecondsSinceEpoch(forcastData[i]["dt"] * 1000);
      forcastData[i]["detail"] = [];

      for (int j = 0; j < detailedForcastData.length; j++) {
        DateTime detailDate = DateTime.fromMillisecondsSinceEpoch(
            detailedForcastData[j]["dt"] * 1000);
        if (detailDate.day == date.day && detailDate.month == date.month) {
          forcastData[i]["detail"].add(detailedForcastData[j]);
        }
      }
    }
    setState(() {
      _forcastData = forcastData;
    });
  }

  Future fetchForcastData(String queryParams) async {
    String url = _baseAPIurl + '/daily?' + queryParams + '&cnt=5';

    // Fetch forcast for the five days.
    var res = await http
        .get(Uri.encodeFull(url), headers: {"X-RapidAPI-Key": _weatherAPIKey});

    if (res.statusCode == 200) {
      var extractData = json.decode(res.body);
      var forcastData = extractData["list"];

      List detailedForcastData = [];
      url = _baseAPIurl + '?' + queryParams;

      // If a forcast for the five days was found,
      // fetch a detailed forcast for each day.
      var detailedRes = await http.get(Uri.encodeFull(url),
          headers: {"X-RapidAPI-Key": _weatherAPIKey});

      if (detailedRes.statusCode == 200) {
        var extractData = json.decode(detailedRes.body);
        detailedForcastData = extractData["list"];

        setState(() {
          _todayTitle = 'Weather today in ' +
              extractData["city"]["name"] +
              ", " +
              extractData["city"]["country"];
        });

        constructFinalList(detailedForcastData, forcastData);
      }
    } else {
      setState(() {
        _forcastData = [];
        _todayTitle = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(35.0, 15, 35.0, 4),
            child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Enter city',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          onPressed('city');
                        })),
                onChanged: (String value) {
                  onChanged('city', value);
                }),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(35.0, 4, 35.0, 4),
            child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Enter coordinates: Lat, Long',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          onPressed('coordinates');
                        })),
                onChanged: (String value) {
                  onChanged('coordinates', value);
                }),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(35.0, 20, 35.0, 4),
              child: Text(_todayTitle)),
          Forcasts(_forcastData)
        ],
      ),
    );
  }
}
