import 'package:flutter/material.dart';

class Forcasts extends StatelessWidget {
  final List forcast;
  Forcasts(this.forcast);

  @override
  Widget build(BuildContext context) {
    if(forcast == null) {
      return Container();
    }
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: forcast
            .map((elem) => Card(
                  child: Container(
                      child:
                        Text(elem["weather"][0]["main"] + '\n'
                           + 'Min: ' + elem["main"]["temp_min"].toString() + '\n'
                           + 'Max: ' + elem["main"]["temp_max"].toString() + '\n'
                           + 'Time: ' + elem["dt_txt"]),
                        
                      padding: const EdgeInsets.all(20.0)),
                ))
            .toList(),
      ),
    );
  }
}
