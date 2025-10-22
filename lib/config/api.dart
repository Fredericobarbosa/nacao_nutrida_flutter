class ApiConfig {
  // Emulador Android (AVD) mapeia localhost da máquina host
  static const String baseUrlAndroid = 'http://10.0.2.2:5000/api';

  // Para Flutter Web / desktop
  static const String baseUrlLocal = 'http://localhost:5000/api';

  // Para dispositivo físico substitua pelo IP da máquina, ex:
  // static const String baseUrlDevice = 'http://192.168.1.10:5000/api';
}
