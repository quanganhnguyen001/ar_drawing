import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector_pro/matrix_gesture_detector_pro.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    super.key,
  });

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
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
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
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
                  child: Opacity(
                    opacity: 0.5,
                    child: MatrixGestureDetector(
                      onMatrixUpdate: (m, tm, sm, rm) {
                        notifier.value = m;
                      },
                      child: AnimatedBuilder(
                        animation: notifier,
                        builder: (ctx, child) {
                          return Transform(
                              transform: notifier.value,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Image.asset(
                                    'assets/1-removebg-preview.png',
                                    width: 300,
                                    height: 300,
                                  ),
                                ],
                              ));
                        },
                      ),
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
