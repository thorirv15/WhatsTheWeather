// Package imports.
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Internal imports.
import './forecasts.dart';

class ForecastListManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForecastListManagerState();
}

class _ForecastListManagerState extends State<ForecastListManager> {
  // Url and key for fetching weather data.
  final String _weatherAPIKey =
      '936547b0cfmsh007bf695be676f6p118acejsn7e2010b5d570';
  final String _baseAPIurl =
      'https://community-open-weather-map.p.rapidapi.com/';

  // Vital variables to keep track of state.
  String _inputCityValue = '', _inputCoordinatesValues = '';
  List _forecastData = [];
  bool _cacheIsClear = true;

  @override
  void initState() {
    // Check if the latest search is stored in cache
    // and should be displayed.
    readFromSharedPreferences();
    super.initState();
  }

  // Reads from cache. Both the last input and the timestamp
  // for that input to check if data should be removed.
  Future readFromSharedPreferences() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final timeStampKey = 'timestamp_key';

    // Start by fetching the timestamp.
    final storedTimeStampStr = sharedPrefs.getString(timeStampKey);
    if (storedTimeStampStr == null) { return; }
    DateTime storedTimeStamp = DateTime.parse(storedTimeStampStr);
    DateTime currentTimeStamp = DateTime.now();

    // If more than 12 hours from stored timestamp,
    // cache will be cleared.
    if (currentTimeStamp.difference(storedTimeStamp).inHours > 12) {
      sharedPrefs.clear();
      setState(() => _cacheIsClear = true);
      return;
    }

    // The most recent weather forecast for the latest
    // search input in the application is fetched if timestamp is valid.
    final searchKey = 'search_key';
    final val = sharedPrefs.getString(searchKey);
    if (val != null) {
      _cacheIsClear = false;
      fetchforecastData(val);
    }
  }

  // Save to cache. Latest search input is stored along
  // with a timestamp of the search so that the user will
  // get the newest most recent forecast based on previous input.
  Future saveToSharedPreferences(String inputSearchKey) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final searchKey = 'search_key';
    final timeStampKey = 'timestamp_key';

    // Cache data.
    await sharedPrefs.setString(timeStampKey, DateTime.now().toString());
    await sharedPrefs.setString(searchKey, inputSearchKey);
    setState(() => _cacheIsClear = false);
  }

  void onPressed(String searchType) {
    // When the button is pressed,
    // the API should be called to fetch data.
    String queryString = '';
    if (searchType == 'city') { queryString = 'q=' + _inputCityValue; } 
    else if (searchType == 'coordinates' &&
        _inputCoordinatesValues.contains(',')) {
      var splitted = _inputCoordinatesValues.split(',');
      queryString = 'lat=' + splitted[0] + '&lon=' + splitted[1];
    }

    // Store search in cache for maximum 12 hours.
    saveToSharedPreferences(queryString);
    // Then fetch forecast data to display.
    fetchforecastData(queryString);
  }

  // State of the input values are set when text
  // is changed in either textfield.
  void onChanged(String searchType, String inputValue) {
    setState(() {
      if (searchType == 'city') { _inputCityValue = inputValue;} 
      else if (searchType == 'coordinates') { _inputCoordinatesValues = inputValue; }
    });
  }

  Future clearCache() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.clear();
    setState(() => _cacheIsClear = true);
  }

  // Construct final list to display.
  void constructFinalList(
      List detailedforecastData, List forecastData, dynamic forecastNowData) {
    // Iterate through the 5 day forecast and for each day,
    // add a detailed forecast for that day.
    for (int i = 0; i < forecastData.length; i++) {
      DateTime date =
          DateTime.fromMillisecondsSinceEpoch(forecastData[i]['dt'] * 1000);

      // Create a new key for the detail part of the data.
      // A list of the 5 days in more detail.
      forecastData[i]['detail'] = [];

      // If it is the first day, add a key for the
      // present weather data.
      if (i == 0) { forecastData[i]['todayForecast'] = forecastNowData; }

      for (int j = 0; j < detailedforecastData.length; j++) {
        DateTime detailDate = DateTime.fromMillisecondsSinceEpoch(
            detailedforecastData[j]['dt'] * 1000);

        if (detailDate.day == date.day && detailDate.month == date.month) {
          forecastData[i]['detail'].add(detailedforecastData[j]);
        }
      }
    }
    // The view will now be updated with the forecast.
    setState(() => _forecastData = forecastData);
  }

  // Fetch the forecasts from the weather API for the present,
  // next five days and the details for the five days.
  // If one of the request fails, no data will be set.
  Future fetchforecastData(String queryParams) async {
    bool fetchedAllData = false;
    String url = _baseAPIurl + 'weather?' + queryParams;

    // Start by fetching the forecast at this moment.
    var forecastNowRes = await http
        .get(Uri.encodeFull(url), headers: {'X-RapidAPI-Key': _weatherAPIKey});

    if (forecastNowRes.statusCode == 200) {
      var extractData = json.decode(forecastNowRes.body);
      var forecastNowData = extractData;

      // Fetch forecast for the next five days.
      url = _baseAPIurl + 'forecast/daily?' + queryParams + '&cnt=5';

      var forecast5dayRes = await http.get(Uri.encodeFull(url),
          headers: {'X-RapidAPI-Key': _weatherAPIKey});

      if (forecast5dayRes.statusCode == 200) {
        extractData = json.decode(forecast5dayRes.body);
        var forecast5dayData = extractData['list'];

        // Finally fetch a detailed forecast for each day.
        url = _baseAPIurl + 'forecast?' + queryParams;

        var detailedRes = await http.get(Uri.encodeFull(url),
            headers: {'X-RapidAPI-Key': _weatherAPIKey});

        if (detailedRes.statusCode == 200) {
          fetchedAllData = true;
          var extractData = json.decode(detailedRes.body);
          var detailedforecastData = extractData['list'];

          // When all data needed has been fetched, the final list
          // will be constructed and state will be set with that list.
          constructFinalList(detailedforecastData, forecast5dayData, forecastNowData);
        }
      }
    }

    // If some data was not fetched. The state will be
    // set as if nothing was found.
    if (!fetchedAllData) { setState(() => _forecastData = []); }
  }

  // The body part of the application is wrapped in a container
  // which has a column lined with containers for the refresh cache
  // button and the input fields. The forecasts ar displayd in a card widget.
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          inputField('Enter city', 'city', 20, 4),
          inputField('Enter coordinates: Lat, Long', 'coordinates', 3, 20),
          Forecasts(_forecastData),
          refreshCacheButton()
        ],
      ),
    );
  }

  // Below are the implementations of the widgets.
  Widget refreshCacheButton() => Container(
      margin: EdgeInsets.fromLTRB(295, 0, 0, 30),
      child: IgnorePointer(
          ignoring: _cacheIsClear,
          child: RaisedButton(
              padding: EdgeInsets.all(8.0),
              child: Text('Refresh Cache'),
              onPressed: () => clearCache())));

  Widget inputField(String hintTextStr, String onPressedStr, double marginT,
          double marginB) =>
      Container(
        margin: EdgeInsets.fromLTRB(35.0, marginT, 35.0, marginB),
        child: TextFormField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                hintText: hintTextStr,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      onPressed(onPressedStr);
                    })),
            onChanged: (String value) {
              onChanged(onPressedStr, value);
            }),
      );
}
