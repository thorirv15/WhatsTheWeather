// Package imports.
import 'package:flutter/material.dart';
// Internal imports.
import './forecast_details.dart';

class Forecasts extends StatelessWidget {
  final List forecast;
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
  Forecasts(this.forecast);

  String kelvinToCelciusStr(var tempInKelvin) =>
      ((tempInKelvin - 272.15).round()).toString() + '°C';

  // The forcast display is in an expanded widget which inhlds
  // a listview where the first item in the list (today) is displayed
  // in a special card, where the detail information will always be
  // displayed along with more details. The next 4 days are stored in
  // expansion tiles which can be clicked to see details for that day.
  @override
  Widget build(BuildContext context) {
    if (forecast == []) {
      return Container();
    }
    return Expanded(
        child: ListView.builder(
      itemCount: forecast.length,
      itemBuilder: (BuildContext context, int index) {
        DateTime currDay =
            DateTime.fromMillisecondsSinceEpoch(forecast[index]['dt'] * 1000);
        List<String> dateStrings = currDay.toString().split(' ')[0].split('-');

        // If item is the current day.
        if (index == 0) {
          return Card(
            margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
            child: Column(
              children: <Widget>[
                currentLocationTitle(index),
                infoRow(currDay, dateStrings, index),
                ForecastDetails(forecast[index]['detail'])
              ],
            ),
          );
        } else {
          return Card(
            child: ExpansionTile(
                leading: dateContainer(currDay, dateStrings, 0, 8),
                title: tempExpansionTileContainer(index),
                children: <Widget>[ForecastDetails(forecast[index]['detail'])],
                trailing: highLowTempContainer(
                    index,
                    forecast[index]['temp']['max'],
                    forecast[index]['temp']['min'],
                    0)),
          );
        }
      },
    ));
  }

  // Below are the implementations of the widgets.
  Widget currentLocationTitle(int index) => Container(
        margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
        child: Text(
            'Weather now in ' +
                forecast[index]['todayForecast']['name'] +
                ', ' +
                forecast[index]['todayForecast']['sys']['country'],
            style: TextStyle(fontSize: 20.0)),
      );

  Widget infoRow(DateTime currDay, List<String> dateStrings, int index) => Row(
        children: <Widget>[
          dateContainer(currDay, dateStrings, 10, 17),
          tempNowContainer(index),
          weatherDescriptionNowContainer(index),
          highLowTempContainer(
              index,
              forecast[index]['todayForecast']['main']['temp_max'],
              forecast[index]['todayForecast']['main']['temp_min'],
              45)
        ],
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

  Widget tempNowContainer(int index) => Container(
      margin: EdgeInsets.fromLTRB(40, 5, 0, 0),
      child: Text(
          kelvinToCelciusStr(forecast[index]['todayForecast']['main']['temp']),
          style: TextStyle(fontSize: 20.0)));

  Widget weatherDescriptionNowContainer(int index) => Container(
      margin: EdgeInsets.fromLTRB(35, 17, 0, 0),
      child: Column(
        children: <Widget>[
          Text(forecast[index]['todayForecast']['weather'][0]['main'],
              style: TextStyle(fontSize: 20.0)),
          Text(
              'Humidity: ' + forecast[index]['todayForecast']['main']['humidity'].toString() + '%',
              style: TextStyle(fontSize: 12.0))
        ],
      ));

  Widget highLowTempContainer(int index, var max, var min, double marginL) =>
      Container(
          margin: EdgeInsets.fromLTRB(marginL, 13, 0, 0),
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

  Widget tempExpansionTileContainer(int index) => Container(
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Text('Average: ' +
                    kelvinToCelciusStr(forecast[index]['temp']['day']))),
            Expanded(child: Text(forecast[index]['weather'][0]['main'])),
          ],
        ),
      );
}
