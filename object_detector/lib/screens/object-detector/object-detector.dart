import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:object_detector/screens/image_previewer/static_image_previewer/static_image_previewer.dart';

class ObjectDetector extends StatefulWidget {
  ObjectDetector({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ObjectDetectorState();
}

class _ObjectDetectorState extends State<ObjectDetector> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final _widgetOptions = <Widget> [
    StaticImagePreviewer(),
    Text(
      'index 1: Dynamic'
    )
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
        title: Text('YOLO object detector'),
        centerTitle: true,
      );

  Widget _bottomNavigationBar() => BottomNavigationBar(
    items: const<BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.camera_alt), title: Text('Static')),
       BottomNavigationBarItem(icon: Icon(Icons.videocam), title: Text('Dynamic')),
    ],
    currentIndex: _selectedIndex,
    selectedItemColor: Colors.tealAccent,
    onTap: _onItemTapped,
    );
}
