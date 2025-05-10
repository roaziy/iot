// lib/services/camera_service.dart
import 'package:camera/camera.dart';

class CameraService {
  static Future<CameraController> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    final controller = CameraController(
      firstCamera,
      ResolutionPreset.low,
      enableAudio: false,
    );

    await controller.initialize();
    return controller;
  }
}
