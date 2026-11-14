import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/app_user.dart';
import '../data/repositories/auth_repository.dart';

class AuthState {
  const AuthState({
    this.user,
    this.pendingUser,
    this.loading = false,
    this.error,
    this.otpVerified = false,
  });

  final AppUser? user;
  final AppUser? pendingUser;
  final bool loading;
  final String? error;
  final bool otpVerified;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    AppUser? user,
    AppUser? pendingUser,
    bool? loading,
    String? error,
    bool? otpVerified,
    bool clearError = false,
    bool clearPending = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      pendingUser: clearPending ? null : (pendingUser ?? this.pendingUser),
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      otpVerified: otpVerified ?? this.otpVerified,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final user = await _repository.login(
        identifier: identifier,
        password: password,
      );
      state = AuthState(user: user);
      return true;
    } on AuthException catch (error) {
      state = state.copyWith(loading: false, error: error.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        loading: false,
        error: 'Connexion impossible. Réessayez.',
      );
      return false;
    }
  }

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final pending = await _repository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      state = state.copyWith(
        loading: false,
        pendingUser: pending,
        otpVerified: false,
      );
      return true;
    } on AuthException catch (error) {
      state = state.copyWith(loading: false, error: error.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        loading: false,
        error: 'Inscription impossible. Réessayez.',
      );
      return false;
    }
  }

  bool verifyOtp(String code) {
    if (code.length != 6) {
      state = state.copyWith(error: 'Saisissez les 6 chiffres du code.');
      return false;
    }
    state = state.copyWith(otpVerified: true, clearError: true);
    return true;
  }

  void completeVerification() {
    final pending = state.pendingUser;
    if (pending == null) return;
    state = AuthState(user: pending);
  }

  void updateProfile({String? firstName, String? lastName, String? email}) {
    final current = state.user;
    if (current == null) return;
    state = state.copyWith(
      user: current.copyWith(
        firstName: firstName,
        lastName: lastName,
        email: email,
      ),
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void logout() {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthRepository());
});
