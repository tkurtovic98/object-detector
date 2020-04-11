
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens/object-detector/object-detector.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ObjectDetector()
    );
  }
}