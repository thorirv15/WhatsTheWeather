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
      'https://community-open-weather-map.p.rapidapi.com/';
  List _forcastData = [];
  String _inputCityValue = '', _inputCoordinatesValues = '';
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
  void constructFinalList(List detailedForcastData, List forcastData, dynamic forcastNowData) {
    for (int i = 0; i < forcastData.length; i++) {
      DateTime date =
          DateTime.fromMillisecondsSinceEpoch(forcastData[i]["dt"] * 1000);
      forcastData[i]["detail"] = [];
      
      // Add the today title (city name and country)
      // to the first object in the list (since that
      // is the current day).
      if(i == 0) {
        forcastData[i]["todayForecast"] = forcastNowData;  
      }
      
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
    bool fetchedAllData = false;
    String url = _baseAPIurl + 'weather?' + queryParams;
    
    // Fetch the forcast at this moment.
    var forcastNowRes = await http
        .get(Uri.encodeFull(url), headers: {"X-RapidAPI-Key": _weatherAPIKey});

    if(forcastNowRes.statusCode == 200) {
      var extractData = json.decode(forcastNowRes.body);
      var forcastNowData = extractData;

      // Fetch forecast for the next five days.
      url = _baseAPIurl + 'forecast/daily?' + queryParams + '&cnt=5';
      
      var forcast5dayRes = await http
        .get(Uri.encodeFull(url), headers: {"X-RapidAPI-Key": _weatherAPIKey});

      if (forcast5dayRes.statusCode == 200) {
        extractData = json.decode(forcast5dayRes.body);
        var forcast5dayData = extractData["list"];
        
        // fetch a detailed forecast for each day.
        url = _baseAPIurl + 'forecast?' + queryParams;

        var detailedRes = await http.get(Uri.encodeFull(url),
          headers: {"X-RapidAPI-Key": _weatherAPIKey});

        if (detailedRes.statusCode == 200) {
          fetchedAllData = true;
          var extractData = json.decode(detailedRes.body);
          var detailedForcastData = extractData["list"];

          constructFinalList(detailedForcastData, forcast5dayData, forcastNowData);
        }
      }
    }
    
    // If some data was not fetched. The state will be 
    // as if nothing was found.
    if(!fetchedAllData) {
      setState(() {
        _forcastData = [];
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
          Forcasts(_forcastData)
        ],
      ),
    );
  }
}
