import 'package:flutter/material.dart';

class Forcasts extends StatelessWidget {
  final List<String> forcasts;
  Forcasts(this.forcasts);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: forcasts.map((elem) =>  Card(
            child: Container(
                child: Text(elem),
                padding: const EdgeInsets.all(20.0)),
          )).toList(),
      ),
    );
  }
  
}
