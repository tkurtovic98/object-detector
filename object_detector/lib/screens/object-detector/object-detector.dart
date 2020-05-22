import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:object_detector/screens/image_previewer/dynamic_image_previewer/dynamic_image_previewer.dart';
import 'package:object_detector/screens/image_previewer/static_image_previewer/static_image_previewer.dart';

List<CameraDescription> list_cameras;

class ObjectDetector extends StatefulWidget {

  ObjectDetector(List<CameraDescription> cameras){
    list_cameras = cameras;
  }

  @override
  State<StatefulWidget> createState() => _ObjectDetectorState();
}

class _ObjectDetectorState extends State<ObjectDetector> {
  int _selectedIndex = 0;
  

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final _widgetOptions = <Widget>[
    StaticImagePreviewer(),
    DynamicImagePreviewer(list_cameras)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _appBar() => AppBar(
        title: Text('Object detector'),
        centerTitle: true,
      );

  Widget _bottomNavigationBar() => BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt), title: Text('Static')),
          BottomNavigationBarItem(
              icon: Icon(Icons.videocam), title: Text('Dynamic')),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.tealAccent,
        onTap: _onItemTapped,
      );
}
