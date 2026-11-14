import '../models/app_user.dart';
import '../services/api_client.dart';

class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Authentification : backend réel si disponible, sinon mode démonstration.
class AuthRepository {
  AuthRepository({ApiClient? api}) : _api = api ?? ApiClient();

  final ApiClient _api;
  bool? _online;

  static const demoEmail = 'demo@alternative.tn';
  static const demoPassword = 'demo1234';

  Future<bool> _isOnline() async {
    _online ??= await _api.health();
    return _online!;
  }

  Future<AppUser> login({
    required String identifier,
    required String password,
  }) async {
    final email = identifier.trim().toLowerCase();

    if (email == demoEmail && password == demoPassword) {
      await Future<void>.delayed(const Duration(milliseconds: 450));
      return const AppUser(
        id: 'u-demo',
        firstName: 'Ahmed Nour',
        lastName: 'Sdiri',
        email: demoEmail,
        phone: '+216 00 000 000',
      );
    }

    if (await _isOnline()) {
      return _api.login(email: email, password: password);
    }

    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (password.length < 6) {
      throw AuthException('E-mail ou mot de passe incorrect.');
    }
    return _demoUserFromEmail(email);
  }

  Future<AppUser> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final normalized = email.trim().toLowerCase();

    if (normalized != demoEmail && await _isOnline()) {
      return _api.register(
        firstName: firstName,
        lastName: lastName,
        email: normalized,
        password: password,
      );
    }

    await Future<void>.delayed(const Duration(milliseconds: 450));
    return AppUser(
      id: 'u-${DateTime.now().millisecondsSinceEpoch}',
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      email: normalized,
      phone: '+216 00 000 000',
    );
  }

  AppUser _demoUserFromEmail(String email) {
    final local = email.split('@').first;
    final parts = local
        .split(RegExp(r'[._-]'))
        .where((part) => part.isNotEmpty)
        .toList();
    final firstName = parts.isNotEmpty
        ? '${parts.first[0].toUpperCase()}${parts.first.substring(1)}'
        : 'Utilisateur';
    final lastName = parts.length > 1
        ? '${parts[1][0].toUpperCase()}${parts[1].substring(1)}'
        : 'Transport';
    return AppUser(
      id: 'u-demo',
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: '+216 00 000 000',
    );
  }
}
