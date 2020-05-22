
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens/object-detector/object-detector.dart';


class App extends StatelessWidget {
  final List<CameraDescription> cameras;
  App(this.cameras);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ObjectDetector(cameras)
    );
  }
}