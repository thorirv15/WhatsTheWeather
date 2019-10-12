// Package imports.
import 'package:flutter/material.dart';

class Forcasts extends StatelessWidget {
  final List forcast;
  final List _weekDays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];
  final List _months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "June",
    "July",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec",
  ];
  Forcasts(this.forcast);

  String kelvinToCelcius(double tempInKelvin) {
    return ((tempInKelvin - 272.15).round()).toString() + "°C";
  }

  @override
  Widget build(BuildContext context) {
    if (forcast == null) {
      return Container();
    }
    return Expanded(
        child: ListView.builder(
      itemCount: forcast.length,
      itemBuilder: (BuildContext context, int index) {
        DateTime currDay = DateTime.fromMillisecondsSinceEpoch(forcast[index]["dt"] * 1000);
        List<String> dateStrings = currDay.toString().split(" ")[0].split("-");
      
        // If item is the current day.
        if (index == 0) {
          return Card(
            margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
            child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                    child: Text(forcast[index]["todayDataStr"], style: TextStyle(fontSize: 20.0)),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 17, 0, 0),
                          child: Column(
                            children: <Widget>[
                              Text(_weekDays[currDay.weekday - 1],
                              style: TextStyle(fontSize: 16.0)),
                              Text(dateStrings[2] + " " + _months[int.parse(dateStrings[1])-1] + " " + dateStrings[0])
                        ],
                      )),
                      Container(
                        margin: EdgeInsets.fromLTRB(40, 5, 0, 0),
                        child: Text(kelvinToCelcius(forcast[index]["todayForecast"]["main"]["temp"]), style: TextStyle(fontSize: 20.0))
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(40, 5, 0, 0),
                        child: Text(forcast[index]["todayForecast"]["weather"][0]["main"], style: TextStyle(fontSize: 20.0))
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(55, 13, 0, 0),
                          child: Column(
                            children: <Widget>[
                              Text('High: ' + kelvinToCelcius(forcast[index]["todayForecast"]["main"]["temp_max"]),
                              style: TextStyle(fontSize: 12.0)),
                              Text('Low: ' + kelvinToCelcius(forcast[index]["todayForecast"]["main"]["temp_min"]),
                              style: TextStyle(fontSize: 12.0, )),
                        ],
                      ))
                    ],
                  ),
                  Column(
                    children: forcast[index]["detail"]
                        .map<Widget>((elem) => Card(
                              child: Container(
                                  child: Text(elem["dt_txt"] +
                                      "  " +
                                      elem["weather"][0]["main"]),
                                  padding: const EdgeInsets.all(20.0)),
                            ))
                        .toList(),
                  )
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
                    Text(dateStrings[2] + " " + _months[int.parse(dateStrings[1])-1] + " " + dateStrings[0])
              ],
            )),
            title: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child:Text('Average: ' + kelvinToCelcius(forcast[index]["temp"]["day"]))
                  ),
                  Expanded(
                    child:Text(forcast[index]["weather"][0]["main"])
                  ),
                ],),
            ),
            children: <Widget>[
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: forcast[index]["detail"]
                      .map<Widget>((elem) => Card(
                            child: Container(
                                child: Text(elem["dt_txt"] +
                                    "  " +
                                    elem["weather"][0]["main"]),
                                padding: const EdgeInsets.all(20.0)),
                          ))
                      .toList(),
                ),
              )
            ],
            trailing: Container(
              margin: EdgeInsets.fromLTRB(0, 13, 0, 0),
                child: Column(
                  children: <Widget>[
                    Text('High: ' + kelvinToCelcius(forcast[index]["temp"]["max"]),
                    style: TextStyle(fontSize: 12.0)),
                    Text('Low: ' + kelvinToCelcius(forcast[index]["temp"]["min"]),
                    style: TextStyle(fontSize: 12.0, )),
              ],
            )),
          ),
        );
      },
    ));
  }
}
