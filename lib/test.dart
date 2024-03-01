import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector_pro/matrix_gesture_detector_pro.dart';

class TransformDemo extends StatefulWidget {
  @override
  State<TransformDemo> createState() => _TransformDemoState();
}

class _TransformDemoState extends State<TransformDemo> {
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
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Transform Demo'),
      ),
      body: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MatrixGestureDetector(
                onMatrixUpdate: (m, tm, sm, rm) {
                  notifier.value = m;
                },
                child: AnimatedBuilder(
                  animation: notifier,
                  builder: (ctx, child) {
                    return Transform(
                        transform: notifier.value,
                        child: Stack(
                          children: [
                            Image.asset('assets/1-removebg-preview.png'),
                          ],
                        ));
                  },
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
