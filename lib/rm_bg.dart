import 'package:ar_drawing/api.dart';
import 'package:ar_drawing/camera_pikachu.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class RemoveBackground extends StatefulWidget {
  const RemoveBackground({super.key});

  @override
  _RemoveBackgroundState createState() => _RemoveBackgroundState();
}

class _RemoveBackgroundState extends State<RemoveBackground> {
  Uint8List? imageFile;

  String? imagePath;

  ScreenshotController controller = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Remove Bg'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Draggable(
                child: Container(
                  height: 50,
                  width: 50,
                  color: Colors.red,
                ),
                feedback: Container(
                  height: 50,
                  width: 50,
                  color: Colors.red,
                ),
                childWhenDragging: Container(),
              ),
            ],
          ),
        ));
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imagePath = pickedImage.path;
        imageFile = await pickedImage.readAsBytes();
        print('1111111111111111111111 ${imagePath!}');
        setState(() {});
      }
    } catch (e) {
      imageFile = null;
      setState(() {});
    }
  }
}
