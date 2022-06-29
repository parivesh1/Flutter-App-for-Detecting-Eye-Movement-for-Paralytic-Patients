import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:testing/main.dart';
import 'package:tflite/tflite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'bndbox.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomePage(this.cameras, {Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic>? _recognitions;
  List<String> gaugedResults = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  bool granted = false;

  @override
  void initState() {
    super.initState();
    permission();
    loadModel();
  }

  permission() async {
    if (granted == false) {
      final statusVid = await Permission.camera.request();
      final statusAud = await Permission.microphone.request();

      if (statusVid == PermissionStatus.granted &&
          statusAud == PermissionStatus.granted) {
        setState(() {
          granted = true;
        });
      }
    }
  }

  loadModel() async {
    String? res = await Tflite.loadModel(
        model: "assets/vgg_model.tflite", labels: "assets/labels.txt");
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
    _recognitions!.map((re) {
      gaugedResults.add(re["label"]);
      debugPrint(gaugedResults.length.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: granted == true
              ? Stack(
                  children: [
                    Camera(widget.cameras, setRecognitions),
                    BndBox(
                        _recognitions == null ? [] : _recognitions!,
                        math.max(_imageHeight, _imageWidth),
                        math.min(_imageHeight, _imageWidth),
                        screenSize.height,
                        screenSize.width),
                  ],
                )
              : SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          const Text(
                            "An error occurred while accessing camera, please grant the camera permission :)",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: ElevatedButton(
                                onPressed: () => permission(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                    "Grant Permission!",
                                    style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "You may have to manually go to settings and enable permission if this button doesn't work!",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }
}
