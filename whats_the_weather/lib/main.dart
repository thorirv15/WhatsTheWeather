import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    // Core root widget.
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Whats The Weather'),
        ),
      ),
    );
  }
}
