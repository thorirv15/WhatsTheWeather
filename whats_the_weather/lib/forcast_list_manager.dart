// Package imports.
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String _inputCityValue = '', _inputCoordinatesValues = '', _todayTitle = '';
  bool _cacheIsClear = true;

  @override
  void initState() {
    // Check if the latest search is stored in cache
    // and should be displayed.
    readFromSharedPreferences();
    super.initState();
  }

  Future readFromSharedPreferences() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final timeStampKey = 'timestamp_key';

    final storedTimeStampStr = sharedPrefs.getString(timeStampKey);
    if(storedTimeStampStr == null) { return; }
    DateTime storedTimeStamp = DateTime.parse(storedTimeStampStr);
    DateTime currentTimeStamp = DateTime.now();

    // If more than 12 hours from stored timestamp,
    // cache will be cleared.
    if (currentTimeStamp.difference(storedTimeStamp).inHours > 12) {
      sharedPrefs.clear();
      setState(() {
        _cacheIsClear = true;  
      });
      return;
    }

    // The most recent weather forcast for the latest
    // search input in the application is fetched.
    final searchKey = 'search_key';
    final val = sharedPrefs.getString(searchKey);
    if (val != null) {
      _cacheIsClear = false;
      fetchForcastData(val);
    }
  }

  // Save to cache. Latest search input is stored along
  // with a timestamp of the search.
  Future saveToSharedPreferences(String inputSearchKey) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final searchKey = 'search_key';
    final timeStampKey = 'timestamp_key';

    await sharedPrefs.setString(timeStampKey, DateTime.now().toString());
    await sharedPrefs.setString(searchKey, inputSearchKey);
    setState(() {
      _cacheIsClear = false;
    });
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

    // Store search in cache for maximum 12 hours.
    saveToSharedPreferences(queryString);
    // Then fetch forcast data to display.
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

  Future clearCache() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.clear();
    setState(() {
      _cacheIsClear = true;
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
            child: IgnorePointer(
              ignoring: _cacheIsClear,
              child: RaisedButton(
                padding: EdgeInsets.all(8.0),
                child: Text('Refresh Cache'),
                onPressed: () => clearCache()
    
            ))
            
          ),
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
              child: Text(_todayTitle, style: TextStyle(fontSize: 20.0))),
          Forcasts(_forcastData)
        ],
      ),
    );
  }
}
