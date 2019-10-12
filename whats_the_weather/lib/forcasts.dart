// Package imports.
import 'package:flutter/material.dart';

// Internal imports.
import './forcast_detail.dart';

class Forcasts extends StatelessWidget {
  final List forcast;
  final List _weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  final List _months = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"];
  Forcasts(this.forcast);

  String kelvinToCelciusStr(var tempInKelvin) => ((tempInKelvin - 272.15).round()).toString() + "°C";

  @override
  Widget build(BuildContext context) {
    if (forcast == null) { return Container(); }
    return Expanded(
        child: ListView.builder(
      itemCount: forcast.length,
      itemBuilder: (BuildContext context, int index) {
        DateTime currDay =
            DateTime.fromMillisecondsSinceEpoch(forcast[index]["dt"] * 1000);
        List<String> dateStrings = currDay.toString().split(" ")[0].split("-");

        // If item is the current day.
        if (index == 0) {
          return Card(
            margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                  child: Text('Weather now in ' + forcast[index]["todayForecast"]["name"] + ', ' + forcast[index]["todayForecast"]["sys"]["country"],
                      style: TextStyle(fontSize: 20.0)),
                ),
                Row(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.fromLTRB(10, 17, 0, 0),
                        child: Column(
                          children: <Widget>[
                            Text(_weekDays[currDay.weekday - 1],
                                style: TextStyle(fontSize: 16.0)),
                            Text(dateStrings[2] +
                                " " +
                                _months[int.parse(dateStrings[1]) - 1] +
                                " " +
                                dateStrings[0])
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.fromLTRB(40, 5, 0, 0),
                        child: Text(
                            kelvinToCelciusStr(forcast[index]["todayForecast"]
                                ["main"]["temp"]),
                            style: TextStyle(fontSize: 20.0))),
                    Container(
                      margin: EdgeInsets.fromLTRB(35, 17, 0, 0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            forcast[index]["todayForecast"]["weather"][0]
                                ["main"],
                            style: TextStyle(fontSize: 20.0)),
                          Text('Humidity: ${forcast[index]["todayForecast"]["main"]["humidity"].toString()} %', style: TextStyle(fontSize: 12.0))
                        ],
                      )),
                    Container(
                        margin: EdgeInsets.fromLTRB(45, 13, 0, 0),
                        child: Column(
                          children: <Widget>[
                            Text(
                                'High: ' +
                                    kelvinToCelciusStr(forcast[index]
                                        ["todayForecast"]["main"]["temp_max"]),
                                style: TextStyle(fontSize: 12.0)),
                            Text(
                                'Low: ' +
                                    kelvinToCelciusStr(forcast[index]
                                        ["todayForecast"]["main"]["temp_min"]),
                                style: TextStyle(
                                  fontSize: 12.0,
                                )),
                          ],
                        ))
                  ],
                ),
                ForcastDetail(forcast[index]["detail"])
              ],
            ),
          );
        }
        return Card(
          child: ExpansionTile(
            leading: Container(
                margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                child: Column(
                  children: <Widget>[
                    Text(_weekDays[currDay.weekday - 1],
                        style: TextStyle(fontSize: 16.0)),
                    Text(dateStrings[2] +
                        " " +
                        _months[int.parse(dateStrings[1]) - 1] +
                        " " +
                        dateStrings[0])
                  ],
                )),
            title: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Text('Average: ' +
                          kelvinToCelciusStr(forcast[index]["temp"]["day"]))),
                  Expanded(child: Text(forcast[index]["weather"][0]["main"])),
                ],
              ),
            ),
            children: <Widget>[
              ForcastDetail(forcast[index]["detail"])
            ],
            trailing: Container(
                margin: EdgeInsets.fromLTRB(0, 13, 0, 0),
                child: Column(
                  children: <Widget>[
                    Text(
                        'High: ' +
                            kelvinToCelciusStr(forcast[index]["temp"]["max"]),
                        style: TextStyle(fontSize: 12.0)),
                    Text(
                        'Low: ' +
                            kelvinToCelciusStr(forcast[index]["temp"]["min"]),
                        style: TextStyle(
                          fontSize: 12.0,
                        )),
                  ],
                )),
          ),
        );
      },
    ));
  }
}
