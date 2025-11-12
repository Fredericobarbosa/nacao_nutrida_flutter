import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart'; 
import 'dart:io'; 

class ApiConfig {
  // URLs base
  static const String _baseUrlAndroidEmulator = 'http://10.0.2.2:5000/api';
  static const String _baseUrlLocal = 'http://localhost:5000/api'; 
  static const String _baseUrlDevice = 'http://192.168.12.5:5000/api'; // IP físico se for rodar em dispositivo real

  static late final String baseUrl;

  // Método de inicialização que será chamado no main.dart
  static Future<void> initialize() async {
    
    // 1. Checa se é WEB
    if (kIsWeb) {
      baseUrl = _baseUrlLocal;
      return;
    }

    // 2. Se não for WEB, checa se é Desktop (Windows, macOS, Linux)
    if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      baseUrl = _baseUrlLocal;
      return;
    }

    // 3. Se não for Web nem Desktop, é MOBILE (Android ou iOS)
    final deviceInfo = DeviceInfoPlugin();
    bool isPhysicalDevice = true;

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        isPhysicalDevice = androidInfo.isPhysicalDevice;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        isPhysicalDevice = iosInfo.isPhysicalDevice;
      }
    } catch (e) {
      print("Erro ao checar device info: $e");
    }

    if (isPhysicalDevice) {
      // É um celular ou tablet FÍSICO
      baseUrl = _baseUrlDevice;
    } else {
      // É um Emulador 
      if (Platform.isAndroid) {
        baseUrl = _baseUrlAndroidEmulator;
      } else if (Platform.isIOS) {
        baseUrl = _baseUrlLocal;
      }
    }
  }
}