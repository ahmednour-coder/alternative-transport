import 'package:flutter/foundation.dart';

abstract final class AppConstants {
  static const appName = 'Alternative Transport';
  static const tagline = 'Roulez plus propre,\naujourd’hui et demain.';

  /// Surcharge optionnelle :
  /// flutter run --dart-define=API_BASE_URL=http://192.168.1.10:3000/api
  static const _apiOverride = String.fromEnvironment('API_BASE_URL');

  /// URL du backend Node/Express + SQLite.
  /// 10.0.2.2 = localhost de la machine vue depuis l'émulateur Android.
  static String get apiBaseUrl {
    if (_apiOverride.isNotEmpty) return _apiOverride;
    final isAndroid =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    return isAndroid
        ? 'http://10.0.2.2:3000/api'
        : 'http://localhost:3000/api';
  }

  static const serviceFee = 2.0;
  static const accessCodeValidity = Duration(minutes: 15);
  static const otpResendDelay = Duration(seconds: 45);

  static const images = 'assets/images';
  static const heroWelcome = '$images/hero_welcome.png';
  static const carBika = '$images/car_bika.png';
  static const carDacia = '$images/car_dacia.png';
  static const carControl = '$images/car_control.png';
  static const mapHome = '$images/map_home.png';
  static const mapTrip = '$images/map_trip.png';
}
