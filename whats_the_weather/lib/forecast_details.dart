// Package imports.
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

class ForecastDetails extends StatelessWidget {
  final List forecastDetails;
  ForecastDetails(this.forecastDetails);

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
      children: forecastDetails
          .map<Widget>((elem) => Card(
                child: Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      children: <Widget>[
                        displayTimeContainer(elem),
                        displayTempContainer(elem),
                        displayWeatherDescriptionContainer(elem),
                        displayHumidityContainer(elem)
                      ],
                    )),
              ))
          .toList(),
    );
  }

  // Below are the implementations of the widgets.
  @widget
  Widget displayTimeContainer(dynamic elem) => Container(
        margin: EdgeInsets.fromLTRB(25, 0, 0, 0),
        child: Text(elem['dt_txt'].split(' ')[1].substring(0, 5),
            style: TextStyle(fontSize: 16.0)),
      );

  @widget
  Widget displayTempContainer(dynamic elem) => Container(
        margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
        child: Text(kelvinToCelciusStr(elem['main']['temp'])),
      );

  @widget
  Widget displayWeatherDescriptionContainer(dynamic elem) => Container(
        margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
        child: Text(elem['weather'][0]['main']),
      );

  @widget
  Widget displayHumidityContainer(dynamic elem) => Container(
        margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
        child: Text('Humidity: ' + elem['main']['humidity'].toString() + '%'),
      );
}
