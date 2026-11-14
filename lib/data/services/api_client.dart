import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/app_constants.dart';
import '../models/app_user.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.isNetworkError = false});

  final String message;
  final bool isNetworkError;

  @override
  String toString() => message;
}

/// Client HTTP minimal vers le backend Node/Express + Prisma.
class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConstants.apiBaseUrl;

  final http.Client _client;
  final String _baseUrl;
  static const _timeout = Duration(seconds: 4);

  Future<bool> health() async {
    try {
      final response = await _client.get(_uri('/health')).timeout(_timeout);
      return response.statusCode < 500;
    } catch (_) {
      return false;
    }
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final response = await _post('/login', {
      'email': email,
      'password': password,
    });
    return AppUser.fromJson(
      Map<String, dynamic>.from(response['user'] as Map),
    );
  }

  Future<AppUser> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final response = await _post('/register', {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    });
    return AppUser.fromJson(
      Map<String, dynamic>.from(response['user'] as Map),
    );
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _client
          .post(
            _uri(path),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400 || decoded['success'] == false) {
        throw ApiException(
          '${decoded['message'] ?? 'Une erreur est survenue.'}',
        );
      }

      return decoded;
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw ApiException('Le serveur ne répond pas.', isNetworkError: true);
    } catch (_) {
      throw ApiException('Serveur indisponible.', isNetworkError: true);
    }
  }

  /// Construit l'URL de l'endpoint.
  /// Accepte une base absolue (`http://localhost:3000/api`) ou relative (`/api`,
  /// utilisée quand le backend est derrière le proxy Nginx de Docker).
  Uri _uri(String path) {
    final raw = '$_baseUrl$path';
    final parsed = Uri.parse(raw);
    if (parsed.hasScheme) return parsed;
    return Uri.base.resolve(raw);
  }
}
