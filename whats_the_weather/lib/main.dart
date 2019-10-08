import 'package:flutter/material.dart';

import './forcast_list_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Core root widget.
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Whats The Weather!'),
        ),
        body: ForcastListManager()
      ),
    );
  }
}
