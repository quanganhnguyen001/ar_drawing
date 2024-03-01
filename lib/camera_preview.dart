import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPreview2 extends StatefulWidget {
  const CameraPreview2({
    super.key,
    required this.imageFile,
  });
  final Uint8List imageFile;

  @override
  _CameraPreview2State createState() => _CameraPreview2State();
}

class _CameraPreview2State extends State<CameraPreview2> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller?.initialize();
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Screen'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller!),
                // Adjust the position, size, etc. of the image as needed
                Positioned(
                  top: 50,
                  left: 50,
                  child: Opacity(
                    opacity: 0.5,
                    child: Image.memory(
                      widget.imageFile,
                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
