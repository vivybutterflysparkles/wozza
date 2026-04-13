import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      // When testing on Chrome/Edge
      return "http://localhost/wozza";
    } else if (!kIsWeb && Platform.isAndroid) {
      // When testing on an Android Emulator
      return "http://10.0.2.2/wozza";
    } else if (!kIsWeb && Platform.isIOS) {
      // When testing on an iOS Simulator
      return "http://127.0.0.1/wozza";
    } else {
      // Fallback for physical devices (update with your IPv4)
      return "http://192.168.1.100/wozza";
    }
  }
}
