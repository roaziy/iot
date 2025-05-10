// lib/screens/camera_screen.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';
import '../services/detection_service.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  bool _isDetecting = false;
  String _status = "Waiting for fire...";

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    _controller = await CameraService.initializeCamera();
    _controller.startImageStream((CameraImage image) async {
      if (_isDetecting) return;
      _isDetecting = true;

      bool fireDetected = await DetectionService.detectFire(image);
      setState(() {
        _status = fireDetected ? "🔥 Fire Detected!" : "✅ Safe";
      });

      _isDetecting = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller),
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              _status,
              style: TextStyle(fontSize: 24, color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
