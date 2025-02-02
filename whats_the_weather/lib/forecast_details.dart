// Package imports.
import 'package:flutter/material.dart';

class ForecastDetails extends StatelessWidget {
  final List _forecastDetails;
  ForecastDetails(this._forecastDetails);

  String kelvinToCelciusStr(var tempInKelvin) =>
      ((tempInKelvin - 272.15).round()).toString() + '°C';

  // The details are placed in a row where each item
  // is a container. The row is then encapsulated by a
  // container encapsulated in a card which is then
  // encapsulated by a column.
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _forecastDetails.map<Widget>(
        (elem) => Card(
          child: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                children: <Widget>[
                  displayTimeContainer(elem),
                  displayTempContainer(elem),
                  displayWeatherDescriptionContainer(elem),
                  displayWindContainer(elem),
                  displayHumidityContainer(elem)
                ]
              )
          )
        )
      ).toList()
    );
  }

  // Below are the implementations of the widgets.
  Widget displayTimeContainer(dynamic elem) => Container(
    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
    child: Text(elem['dt_txt'].split(' ')[1].substring(0, 5),
        style: TextStyle(fontSize: 16.0))
  );

  Widget displayTempContainer(dynamic elem) => Container(
    margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
    child: Text(kelvinToCelciusStr(elem['main']['temp']))
  );

  Widget displayWindContainer(dynamic elem) => Container(
    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
    child: Text(elem['wind']['speed'].toString() + ' m/s')
  );

  Widget displayWeatherDescriptionContainer(dynamic elem) => Container(
    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
    child: Text(elem['weather'][0]['main'])
  );

  Widget displayHumidityContainer(dynamic elem) => Container(
    margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
    child: Text('Humidity: ' + elem['main']['humidity'].toString() + '%')
  );
}
