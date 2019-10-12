// Package imports.
import 'package:flutter/material.dart';

class ForcastDetail extends StatelessWidget {
  
  final List forcastDetails;
  ForcastDetail(this.forcastDetails);
  
  String kelvinToCelciusStr(var tempInKelvin) => ((tempInKelvin - 272.15).round()).toString() + "°C";

  @override
  Widget build(BuildContext context) {
    
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: forcastDetails
            .map<Widget>((elem) => Card(
                  child: Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(

                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(25, 0, 0, 0),
                            child: Text(elem["dt_txt"].split(" ")[1].substring(0,5), style: TextStyle(fontSize: 16.0)),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                            child: Text(kelvinToCelciusStr(elem["main"]["temp"])),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                            child: Text(elem["weather"][0]["main"]),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                            child: Text('Humidity: ' + elem["main"]["humidity"].toString() + "%"),
                          ),
                      ],)
                  ),
                ))
            .toList(),
    );
  }
}
