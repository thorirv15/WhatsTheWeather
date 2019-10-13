// Package imports.
import 'package:flutter/material.dart';

// Internal imports.
import './forecast_list_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Core root widget.
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Center(child: Text('Whats The Weather'))),
          // ForecastListManager displays and manages the
          // weather forecast.
          body: ForecastListManager()),
    );
  }
}
