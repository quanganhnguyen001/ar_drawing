import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector_pro/matrix_gesture_detector_pro.dart';

class CameraScreen3 extends StatefulWidget {
  const CameraScreen3({
    super.key,
    required this.imageFile,
  });
  final Uint8List imageFile;

  @override
  _CameraScreen3State createState() => _CameraScreen3State();
}

class _CameraScreen3State extends State<CameraScreen3> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool isFlipped = false;
  bool isLocked = true;
  var isActived = false;
  // var controller =

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
                      child: isLocked
                          ? AnimatedBuilder(
                              animation: notifier,
                              builder: (ctx, child) {
                                return Transform(
                                  transform: notifier.value,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Transform.flip(
                                        flipX: isFlipped,
                                        child: Image.memory(
                                          widget.imageFile,
                                          width: 400,
                                          height: 400,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Transform.flip(
                                  flipX: isFlipped,
                                  child: Image.memory(
                                    widget.imageFile,
                                    width: 400,
                                    height: 400,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLocked = !isLocked;
                          });
                        },
                        child: Text(isLocked ? "Lock" : "Unlock"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isFlipped = !isFlipped;
                          });
                        },
                        child: Text(
                          "Flip",
                        ),
                      ),
                    ],
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
