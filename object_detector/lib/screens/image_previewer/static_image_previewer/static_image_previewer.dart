import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class StaticImagePreviewer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StaticImagePreviewerState();
}

class _StaticImagePreviewerState extends State<StaticImagePreviewer> {
  File _image;
  List _recognitions;
  double _imageHeight;
  double _imageWidth;
  bool _busy = false;

  Future predictImagePicker(ImageSource option) async {
    _image = null;
    var image = await ImagePicker.pickImage(source: option);
    if (image == null) return;
    setState(() => _busy = true);
    predictImage(image);
  }

  Future<void> imagePickerOptions() async {
    var option = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select photo source'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
                child: const Text('Gallery'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, ImageSource.camera);
                },
                child: const Text('Camera'),
              ),
            ],
          );
        });
    predictImagePicker(option);
  }

  Future predictImage(File image) async {
    if (image == null) return;

    await runModel(image);

    new FileImage(image)
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageHeight = info.image.height.toDouble();
        _imageWidth = info.image.width.toDouble();
      });
    }));

    setState(() {
      _image = image;
      _busy = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _busy = true;
    loadModel().then((value) => setState(() => _busy = false));
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

  Future runModel(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path,
        numResultsPerClass: 2, // defaults to 5
        threshold: 0.4, // defaults to 0.1
        );
    setState(() => _recognitions = recognitions);
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageHeight == null || _imageWidth == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageWidth * screen.width;
    Color blue = Color.fromRGBO(37, 213, 253, 1.0);
    return _recognitions.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: blue,
              width: 2,
            ),
          ),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = blue,
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];

    stackChildren.add(Positioned(
      top: 0.0,
      left: 0.0,
      width: size.width,
      child: _image == null ? Text('No image selected.') : Image.file(_image),
    ));

    if (_busy) {
      stackChildren.add(const Opacity(
        child: ModalBarrier(dismissible: false, color: Colors.grey),
        opacity: 0.3,
      ));
      stackChildren.add(const Center(child: CircularProgressIndicator()));
    }

    stackChildren.addAll(renderBoxes(size));

    return Scaffold(
      body: Stack(
        children: stackChildren,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: imagePickerOptions,
        tooltip: 'Pick Image',
        child: Icon(Icons.image),
      ),
    );
  }
}
