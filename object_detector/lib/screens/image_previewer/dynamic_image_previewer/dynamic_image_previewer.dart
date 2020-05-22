import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:object_detector/bndbox.dart';
import 'dart:math' as math;
import 'package:object_detector/camera.dart';

class DynamicImagePreviewer extends StatefulWidget {
  final List<CameraDescription> cameras;
  DynamicImagePreviewer(this.cameras);
  @override
  State<StatefulWidget> createState() => _DynamicImagePreviewerState();
}

class _DynamicImagePreviewerState extends State<DynamicImagePreviewer> {
  List _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

 
  @override
  void initState() {
    super.initState();
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  Future loadModel() async {
    Tflite.close();
    try {
      final res = await Tflite.loadModel(
          model: "assets/ssd-tflite-model.tflite",
          labels: "assets/pet_label_list.txt");

      print('Model loaded: ' + res);
    } on PlatformException {
      print('Failed to load model.');
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Camera(
            widget.cameras,
            setRecognitions
          ),
          BndBox (
            _recognitions == null ? [] : _recognitions,
            math.max(_imageHeight, _imageWidth),
            math.min(_imageHeight, _imageWidth),
            size.height,
            size.width,
          )
        ]
      ),
    );
  }
}
