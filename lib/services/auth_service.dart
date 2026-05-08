import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';

class AuthService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static const _tokenKey = 'auth_token';
  static String? _cachedToken;

  static Future<String?> getToken() async {
    if (_cachedToken != null) {
      return _cachedToken;
    }

    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_tokenKey);
    return _cachedToken;
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    _cachedToken = token;
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    _cachedToken = null;
  }

  static Future<void> login(String username, String password) async {
    final uri = Uri.http(AppConfig.backendUrl, '/auth/api/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('Greška ${response.statusCode}: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final token = body['token'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception('Token nije pronađen u odgovoru.');
    }

    await saveToken(token);
  }

  static Future<Map<String, String>> authHeaders([Map<String, String>? extra]) async {
    final token = await getToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (extra != null) ...extra,
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<bool> _handleUnauthorized(http.Response response) async {
    if (response.statusCode != 401) {
      return false;
    }

    await clearToken();
    final navigatorState = navigatorKey.currentState;
    if (navigatorState != null) {
      navigatorState.pushNamedAndRemoveUntil('/login', (route) => false);
    }
    return true;
  }

  static Future<http.Response> authenticatedGet(Uri uri, {Map<String, String>? headers}) async {
    final auth = await authHeaders(headers);
    final response = await http.get(uri, headers: auth);
    await _handleUnauthorized(response);
    return response;
  }

  static Future<http.Response> authenticatedPost(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final auth = await authHeaders(headers);
    final response = await http.post(uri, headers: auth, body: body, encoding: encoding);
    await _handleUnauthorized(response);
    return response;
  }
}
