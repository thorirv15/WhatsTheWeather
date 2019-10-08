import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import './forcasts.dart';

class ForcastListManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForcastListManagerState();
  }
}

class _ForcastListManagerState extends State<ForcastListManager> {
  final List<String> _forcasts = ['First day', 'Second day'];
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            child: Forcasts(_forcasts)
        );
      },
    );
  }
}
