import 'dart:typed_data';

import 'package:background_remover/background_remover.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class ImageProcessingScreen extends StatefulWidget {
  @override
  _ImageProcessingScreenState createState() => _ImageProcessingScreenState();
}

class _ImageProcessingScreenState extends State<ImageProcessingScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Processing'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _imageData != null
                ? Image.memory(_imageData!)
                : Text('No image selected'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndProcessImage,
        tooltip: 'Pick and Process Image',
        child: Icon(Icons.image),
      ),
    );
  }
}
