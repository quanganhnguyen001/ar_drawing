import 'dart:typed_data';
import 'package:ar_drawing/sketch_image2.dart';
import 'package:image/image.dart' as img;
import 'package:ar_drawing/api.dart';
import 'package:ar_drawing/camera_preview.dart';
import 'package:ar_drawing/camera_pikachu.dart';
import 'package:ar_drawing/rm_bg.dart';
import 'package:ar_drawing/sketch_image.dart';
import 'package:background_remover/background_remover.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';

class DemoAR extends StatefulWidget {
  const DemoAR({super.key});

  @override
  State<DemoAR> createState() => _DemoARState();
}

class _DemoARState extends State<DemoAR> {
  Uint8List? imageFile;

  Uint8List? _imageData;
  bool _isLoading = false;

  Future<void> _pickAndProcessImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
      });

      final imageBytes = await pickedFile.readAsBytes();

      // First, remove the background
      final processedImage = await removeBackground(imageBytes: imageBytes);

      // Then, convert the resulting image to line art
      final originalImage = img.decodeImage(processedImage);
      final grayscaleImage = img.grayscale(originalImage!);
      final lineArtImage = img.sobel(grayscaleImage);
      final invertedImage = img.invert(lineArtImage);

      setState(() {
        _imageData = Uint8List.fromList(img.encodePng(invertedImage));
        _isLoading = false;
      });
    }
  }

  ScreenshotController controller = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo AR'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CameraScreen()));
                },
                child: Text('Pikachu')),
            ElevatedButton(
                onPressed: () async {
                  await _pickAndProcessImage();

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CameraScreen3(
                            imageFile: _imageData!,
                          )));
                },
                child: Text('Sketch image form libary')),
          ],
        ),
      ),
    );
  }
}
