import 'package:camera/camera.dart';
import 'dart:typed_data';

class DetectionService {
  static Future<bool> detectFire(CameraImage image) async {
    // Note: Simple fake detection based on image brightness & red pixels
    // For real fire detection, use TensorFlow Lite models

    try {
      int redPixels = 0;
      int totalPixels = 0;

      // Only look at the Y (luma) channel from YUV
      final bytes = image.planes[0].bytes;
      for (int i = 0; i < bytes.length; i += 30) {
        final pixel = bytes[i];
        if (pixel > 200) redPixels++; // brighter parts
        totalPixels++;
      }

      double brightness = (redPixels / totalPixels) * 100;
      print("Brightness ~ fire percent: $brightness%");

      return brightness > 25; // Trigger fire if brightness pattern is strong
    } catch (e) {
      print("Detection error: $e");
      return false;
    }
  }
}
