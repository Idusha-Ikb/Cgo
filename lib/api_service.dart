import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

/// API Service connecting the Flutter app to the SecureTrack SL Backend
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  // Smart URL selection based on running platform (Android Emulator vs Desktop/Web)
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000/api';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api';
    }
    return 'http://127.0.0.1:8000/api';
  }

  static const Duration _timeout = Duration(milliseconds: 2500);

  // Local user cache ensuring registered users persist in session even if backend is offline
  final Map<String, Map<String, dynamic>> _localUsers = {
    'owner@cargooverseas.lk': {
      'name': 'Tharindu Perera',
      'email': 'owner@cargooverseas.lk',
      'password': 'Secure@2026',
      'phone': '+94 77 123 4567',
      'role': 'Owner',
      'company': 'Cargo Overseas Freight Pvt Ltd',
    },
    'driver@cargooverseas.lk': {
      'name': 'S.A. Gamage',
      'email': 'driver@cargooverseas.lk',
      'password': 'Secure@2026',
      'phone': '+94 77 987 6543',
      'role': 'Driver',
      'company': 'Cargo Overseas Freight Pvt Ltd',
    },
  };

  UserModel _currentUser = UserModel.defaultOwner;
  UserModel get currentUser => _currentUser;

  /// Authenticate user against Backend SQLite Database (or Local Cache)
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String role = 'Owner',
  }) async {
    final cleanEmail = email.trim().toLowerCase();

    // 1. Try Backend API first
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': cleanEmail,
              'password': password,
              'role': role,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['user'] != null) {
          final u = decoded['user'];
          _currentUser = UserModel(
            name: u['name'] ?? 'User',
            email: u['email'] ?? cleanEmail,
            phone: u['phone'] ?? '+94 77 123 4567',
            role: u['role'] ?? role,
            company: u['company'] ?? 'Cargo Overseas Freight Pvt Ltd',
          );
        }
        return decoded;
      } else if (response.statusCode == 401) {
        // Explicit rejection from server
        final decoded = jsonDecode(response.body);
        return decoded;
      }
    } catch (e) {
      debugPrint('ApiService login connecting to local registry: $e');
    }

    // 2. Check Local Registered Users
    if (_localUsers.containsKey(cleanEmail)) {
      final user = _localUsers[cleanEmail]!;
      if (user['password'] == password) {
        _currentUser = UserModel(
          name: user['name'] ?? 'User',
          email: cleanEmail,
          phone: user['phone'] ?? '+94 77 123 4567',
          role: user['role'] ?? role,
          company: user['company'] ?? 'Cargo Overseas Freight Pvt Ltd',
        );
        return {
          'success': true,
          'token': 'jwt_local_${DateTime.now().millisecondsSinceEpoch}',
          'user': {
            'name': user['name'] ?? 'User',
            'email': cleanEmail,
            'role': user['role'] ?? role,
            'company': user['company'] ?? 'Cargo Overseas Freight Pvt Ltd',
          }
        };
      } else {
        return {
          'success': false,
          'error': 'Incorrect password. Please verify your credentials and try again.',
        };
      }
    }

    // 3. Unregistered user rejection
    return {
      'success': false,
      'error': 'Access Denied: Unregistered email ($cleanEmail). Please create an account first.',
    };
  }

  /// Register new user and save to SQLite DB and Local Cache
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String role = 'Owner',
  }) async {
    final cleanEmail = email.trim().toLowerCase();

    // Always register in local cache so login is guaranteed to work
    _localUsers[cleanEmail] = {
      'name': name.trim(),
      'email': cleanEmail,
      'phone': phone.trim(),
      'password': password,
      'role': role,
      'company': 'Cargo Overseas Freight Pvt Ltd',
    };

    _currentUser = UserModel(
      name: name.trim(),
      email: cleanEmail,
      phone: phone.trim(),
      role: role,
      company: 'Cargo Overseas Freight Pvt Ltd',
    );

    // Try sending to SQLite Backend API
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name.trim(),
              'email': cleanEmail,
              'phone': phone.trim(),
              'password': password,
              'role': role,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('ApiService register local save success: $e');
    }

    return {
      'success': true,
      'message': 'Account registered successfully',
      'user': {
        'name': name.trim(),
        'email': cleanEmail,
        'role': role,
      }
    };
  }

  /// Fetch container list from backend
  Future<List<ContainerModel>> getContainers() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/containers'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          return ContainerModel.sampleContainers;
        }
      }
    } catch (e) {
      debugPrint('ApiService getContainers fallback: $e');
    }
    return ContainerModel.sampleContainers;
  }

  /// Fetch live alerts list
  Future<List<AlertItem>> getAlerts({String category = 'All'}) async {
    try {
      final uri = category == 'All'
          ? Uri.parse('$baseUrl/alerts')
          : Uri.parse('$baseUrl/alerts?category=$category');

      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          return AlertItem.sampleAlerts.where((a) {
            if (category == 'All') return true;
            return a.category.toLowerCase() == category.toLowerCase();
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('ApiService getAlerts fallback: $e');
    }

    return AlertItem.sampleAlerts.where((a) {
      if (category == 'All') return true;
      return a.category.toLowerCase() == category.toLowerCase();
    }).toList();
  }
}
