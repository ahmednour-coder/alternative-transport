import 'package:flutter/material.dart';

import '../../data/models/access_code.dart';
import '../../data/models/trip.dart';
import '../../data/models/vehicle.dart';
import '../../data/services/mock_data.dart';
import '../../core/constants/app_constants.dart';
import '../../screens/auth/document_capture_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/otp_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/verification_screen.dart';
import '../../screens/documents/documents_screen.dart';
import '../../screens/history/reservations_screen.dart';
import '../../screens/home/filters_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/key/access_code_screen.dart';
import '../../screens/key/ble_connection_screen.dart';
import '../../screens/key/trip_in_progress_screen.dart';
import '../../screens/key/trip_summary_screen.dart';
import '../../screens/key/vehicle_control_screen.dart';
import '../../screens/map/map_screen.dart';
import '../../screens/onboarding/brand_screen.dart';
import '../../screens/onboarding/welcome_screen.dart';
import '../../screens/profile/payment_methods_screen.dart';
import '../../screens/profile/personal_info_screen.dart';
import '../../screens/profile/preferences_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/support_screen.dart';
import '../../screens/reservation/reservation_screen.dart';
import '../../screens/reservation/vehicle_detail_screen.dart';
import '../../screens/splash/splash_screen.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const brand = '/brand';
  static const login = '/login';
  static const register = '/register';
  static const otp = '/otp';
  static const capture = '/capture';
  static const verification = '/verification';
  static const home = '/home';
  static const filters = '/filters';
  static const map = '/map';
  static const vehicle = '/vehicle';
  static const reservation = '/reservation';
  static const accessCode = '/access-code';
  static const ble = '/bluetooth';
  static const control = '/vehicle/control';
  static const trip = '/trip';
  static const tripSummary = '/trip/summary';
  static const reservations = '/reservations';
  static const profile = '/profile';
  static const documents = '/documents';
  static const personalInfo = '/profile/informations';
  static const payments = '/profile/paiements';
  static const preferences = '/profile/preferences';
  static const support = '/profile/support';

  static String tabFor(int index) => switch (index) {
        0 => home,
        1 => map,
        2 => reservations,
        _ => profile,
      };
}

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _page(const SplashScreen(), settings);
      case AppRoutes.welcome:
        return _page(const WelcomeScreen(), settings);
      case AppRoutes.brand:
        return _page(const BrandScreen(), settings);
      case AppRoutes.login:
        return _page(const LoginScreen(), settings);
      case AppRoutes.register:
        return _page(const RegisterScreen(), settings);
      case AppRoutes.otp:
        final email = settings.arguments is String
            ? settings.arguments as String
            : 'votre adresse e-mail';
        return _page(OtpScreen(email: email), settings);
      case AppRoutes.capture:
        final args = settings.arguments is DocumentCaptureArgs
            ? settings.arguments as DocumentCaptureArgs
            : const DocumentCaptureArgs(kind: CaptureKind.cinRecto);
        return _page(DocumentCaptureScreen(kind: args.kind), settings);
      case AppRoutes.verification:
        return _page(const VerificationScreen(), settings);
      case AppRoutes.home:
        return _page(const HomeScreen(), settings);
      case AppRoutes.filters:
        return _page(const FiltersScreen(), settings);
      case AppRoutes.map:
        return _page(const MapScreen(), settings);
      case AppRoutes.vehicle:
        return _page(VehicleDetailScreen(vehicle: _vehicle(settings)), settings);
      case AppRoutes.reservation:
        return _page(ReservationScreen(vehicle: _vehicle(settings)), settings);
      case AppRoutes.accessCode:
        final args = settings.arguments;
        final demoArgs = args is AccessCodeArgs ? args : _demoAccessCode();
        return _page(
          AccessCodeScreen(code: demoArgs.code, vehicle: demoArgs.vehicle),
          settings,
        );
      case AppRoutes.ble:
        return _page(BleConnectionScreen(vehicle: _vehicle(settings)), settings);
      case AppRoutes.control:
        return _page(VehicleControlScreen(vehicle: _vehicle(settings)), settings);
      case AppRoutes.trip:
        return _page(TripInProgressScreen(vehicle: _vehicle(settings)), settings);
      case AppRoutes.tripSummary:
        final args = settings.arguments;
        return _page(
          TripSummaryScreen(trip: args is Trip ? args : _demoTrip()),
          settings,
        );
      case AppRoutes.reservations:
        return _page(const ReservationsScreen(), settings);
      case AppRoutes.profile:
        return _page(const ProfileScreen(), settings);
      case AppRoutes.documents:
        return _page(const DocumentsScreen(), settings);
      case AppRoutes.personalInfo:
        return _page(const PersonalInfoScreen(), settings);
      case AppRoutes.payments:
        return _page(const PaymentMethodsScreen(), settings);
      case AppRoutes.preferences:
        return _page(const PreferencesScreen(), settings);
      case AppRoutes.support:
        return _page(const SupportScreen(), settings);
      default:
        return _page(const WelcomeScreen(), settings);
    }
  }

  /// Véhicule de démonstration : permet d'ouvrir un écran par lien direct
  /// (http://localhost:8080/#/vehicle) sans passer par la navigation interne.
  static Vehicle _vehicle(RouteSettings settings) {
    final args = settings.arguments;
    return args is Vehicle ? args : MockData.vehicles.first;
  }

  static AccessCodeArgs _demoAccessCode() {
    final now = DateTime.now();
    final vehicle = MockData.vehicles.first;
    return AccessCodeArgs(
      code: AccessCode(
        code: '482913',
        issuedAt: now,
        expiresAt: now.add(AppConstants.accessCodeValidity),
        vehicleId: vehicle.id,
      ),
      vehicle: vehicle,
    );
  }

  static Trip _demoTrip() {
    final now = DateTime.now();
    return Trip(
      vehicle: MockData.vehicles.first,
      startedAt: now.subtract(const Duration(minutes: 42)),
      duration: const Duration(minutes: 42),
      distanceKm: 12.4,
      cost: 9.6,
    );
  }

  static MaterialPageRoute<dynamic> _page(
    Widget screen,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => screen,
      settings: settings,
    );
  }
}

/// Petit utilitaire de navigation utilisé par les écrans de la clé.
AccessCode buildAccessCodeFrom(AccessCode code) => code;
