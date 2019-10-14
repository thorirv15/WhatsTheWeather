// Package imports.
import 'package:flutter/material.dart';
// Internal imports.
import './forecast_details.dart';

class Forecasts extends StatelessWidget {
  final String _getIconUrl = 'http://openweathermap.org/img/w/';
  final List _forecast;
  final List _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec'
  ];
  Forecasts(this._forecast);

  String kelvinToCelciusStr(var tempInKelvin) =>
      ((tempInKelvin - 272.15).round()).toString() + '°C';

  // The forcast display is in an expanded widget which inhlds
  // a listview where the first item in the list (today) is displayed
  // in a special card, where the detail information will always be
  // displayed along with more details. The next 4 days are stored in
  // expansion tiles which can be clicked to see details for that day.
  @override
  Widget build(BuildContext context) {
    if (_forecast == []) { return Container(); }
    return Expanded(
        child: ListView.builder(
      itemCount: _forecast.length,
      itemBuilder: (BuildContext context, int index) {
        DateTime currDay =
            DateTime.fromMillisecondsSinceEpoch(_forecast[index]['dt'] * 1000);
        List<String> dateStrings = currDay.toString().split(' ')[0].split('-');

        // If item is the current day.
        if (index == 0) {
          return Card(
            margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
            child: Column(
              children: <Widget>[
                currentLocationTitle(index),
                infoRow(currDay, dateStrings, index),
                ForecastDetails(_forecast[index]['detail'])
              ],
            ),
          );
        } else {
          return Card(
            child: ExpansionTile(
                leading: dateContainer(currDay, dateStrings, 0, 8),
                title: Container(
                  child: Row(
                    children: <Widget>[
                      tempContainer(_forecast[index]['temp']['day'], 17, 0),
                      weatherDescriptionContainer(
                          _forecast[index]['weather'][0]['icon'],
                          _forecast[index]['weather'][0]['main'],
                          30,
                          0,
                          0)
                    ],
                  ),
                ),
                children: <Widget>[ForecastDetails(_forecast[index]['detail'])],
                trailing: highLowTempContainer(
                    index,
                    _forecast[index]['temp']['max'],
                    _forecast[index]['temp']['min'],
                    0,
                    13)),
          );
        }
      },
    ));
  }

  // Below are the implementations of the widgets.
  Widget currentLocationTitle(int index) => Container(
        margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: Text(
          _forecast[index]['todayForecast']['name'] +
              ', ' +
              _forecast[index]['todayForecast']['sys']['country'],
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      );

  Widget infoRow(DateTime currDay, List<String> dateStrings, int index) => Row(
        children: <Widget>[
          tempContainer(
              _forecast[index]['todayForecast']['main']['temp'], 60, 3),
          weatherDescriptionContainer(
              _forecast[index]['todayForecast']['weather'][0]['icon'],
              _forecast[index]['todayForecast']['weather'][0]['main'],
              25,
              10,
              8),
          Column(
            children: <Widget>[
              displayHumidityContainer(_forecast[index]['todayForecast']['main']['humidity'].toString()),
              displayWindContainer(_forecast[index]['todayForecast']['wind']['speed'].toString())
            ],
          )
          
        ],
      );

  Widget displayHumidityContainer(String humidity) => Container(
        margin: EdgeInsets.fromLTRB(60, 0, 0, 0),
        child: Text('Humidity: ' + humidity + '%'),
      );

  Widget displayWindContainer(String wind) => Container(
    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
    child: Text(wind + ' m/s'),
  );

  Widget dateContainer(DateTime currDay, List<String> dateStrings,
          double marginL, double marginT) =>
      Container(
          margin: EdgeInsets.fromLTRB(marginL, marginT, 0, 0),
          child: Column(
            children: <Widget>[
              Text(_weekDays[currDay.weekday - 1],
                  style: TextStyle(fontSize: 16.0)),
              Text(dateStrings[2] +
                  ' ' +
                  _months[int.parse(dateStrings[1]) - 1] +
                  ' ' +
                  dateStrings[0])
            ],
          ));

  Widget tempContainer(var tempature, double marginL, double marginT) =>
      Container(
          margin: EdgeInsets.fromLTRB(marginL, marginT, 0, 0),
          child: Text(kelvinToCelciusStr(tempature),
              style: TextStyle(fontSize: 20.0)));

  Widget weatherDescriptionContainer(
          String icon, String descr, double marginL, double marginT, double marginB) =>
      Container(
          margin: EdgeInsets.fromLTRB(marginL, marginT, 0, marginB),
          child: Row(
            children: <Widget>[
              Image.network(_getIconUrl + icon + '.png'),
              Text(descr, style: TextStyle(fontSize: 20.0))
            ],
          ));

  Widget highLowTempContainer(
          int index, var max, var min, double marginL, double marginT) =>
      Container(
          margin: EdgeInsets.fromLTRB(marginL, marginT, 0, 0),
          child: Column(
            children: <Widget>[
              Text('High: ' + kelvinToCelciusStr(max),
                  style: TextStyle(fontSize: 12.0)),
              Text('Low: ' + kelvinToCelciusStr(min),
                  style: TextStyle(
                    fontSize: 12.0,
                  )),
            ],
          ));
}
