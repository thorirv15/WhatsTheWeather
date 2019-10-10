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
  final String _weatherAPIKey = '936547b0cfmsh007bf695be676f6p118acejsn7e2010b5d570';
  final String _baseAPIurl = 'https://community-open-weather-map.p.rapidapi.com/forecast';
  String _inputCityValue = '', _inputCoordinatesValues = '';
  List _forcastData = [];
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

    fetchForcastData(queryString);
    
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

  // Construct final list to display.
  void constructFinalList(List detailedForcastData, List forcastData) {
    for (int i = 0; i < forcastData.length; i++) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(forcastData[i]["dt"] * 1000);
      forcastData[i]["detail"] = []; 

      for(int j = 0; j < detailedForcastData.length; j++) {
        DateTime detailDate = DateTime.fromMillisecondsSinceEpoch(detailedForcastData[j]["dt"] * 1000);
        if(detailDate.day == date.day && detailDate.month == date.month) {
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
    var res = await http.get(
      Uri.encodeFull(url),
      headers: {"X-RapidAPI-Key": _weatherAPIKey}
    );

    if(res.statusCode == 200) {
      var extractData = json.decode(res.body);
      var forcastData = extractData["list"];
      // _city = extractData["city"]["name"] + ", ";
      // _country = extractData["city"]["country"];
      
      List detailedForcastData = [];
      url = _baseAPIurl + '?' + queryParams;
   
      // If a forcast for the five days was found,
      // fetch a detailed forcast for each day.
      var detailedRes = await http.get(
        Uri.encodeFull(url),
        headers: {"X-RapidAPI-Key": _weatherAPIKey}
      );

      if(detailedRes.statusCode == 200) {
        var extractData = json.decode(detailedRes.body);
        detailedForcastData = extractData["list"];

        setState(() {
          _city = extractData["city"]["name"] + ", ";
          _country = extractData["city"]["country"];
        });

        constructFinalList(detailedForcastData, forcastData);
      }
    }
    else {
      setState(() {
        _forcastData = [];
        _city = "";
        _country = "";
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          
          Container (
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
                  onChanged: (String value) {onChanged('city', value);}
            ),
          ),

          Container (
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
                  onChanged: (String value) {onChanged('coordinates', value);}
            ),
          ),
          

          Container(
            margin: EdgeInsets.fromLTRB(35.0, 4, 35.0, 4),
            child: Text(_city + _country)
          ),

          Forcasts(_forcastData)

      ],),
    );
  
    // return ListView.builder(
    //   itemCount: 1,
    //   itemBuilder: (BuildContext context, int index) {
    //     return Container(
    //       child: Column(
    //         children: <Widget>[
    //           Container(
    //             padding: EdgeInsets.all(35.0),
    //             child: TextField(
    //               decoration: InputDecoration(
    //                   border: OutlineInputBorder(), 
    //                   labelText: 'Enter a city'),
    //                   onChanged: (String value) {onChanged('city', value);}
    //             ),
    //           ),
    //           RaisedButton(
    //             child: Text('Find'),
    //             onPressed: () { onPressed('city'); },
    //           ),
    //           Container(
    //             padding: EdgeInsets.all(35.0),
    //             child: TextField(
    //               decoration: InputDecoration(
    //                   border: OutlineInputBorder(), 
    //                   labelText: 'Enter coordinates: Lat, Long'),
    //                   onChanged: (String value) {onChanged('coordinates', value);},
    //             ),
    //           ),
    //           RaisedButton(
    //             child: Text('Find'),
    //             onPressed: () { onPressed('coordinates'); },
    //           ),
    //           Text(_city),
    //           Text(_country),
    //           Forcasts(_weatherData)
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}
