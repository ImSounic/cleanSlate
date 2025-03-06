// frontend/lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Base URL of your Python backend
  final String baseUrl = 'http://127.0.0.1:8000';

  // Key for storing the auth token in shared preferences
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';

  // Register a new user
  Future<Map<String, dynamic>> register(
      {required String fullName,
      String? email,
      String? phone,
      required String password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['detail'] ?? 'Failed to register user');
    }
  }

  // Login user
  Future<Map<String, dynamic>> login(
      {String? email, String? phone, required String password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Store tokens and user data in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(tokenKey, data['session']['access_token']);
      await prefs.setString(refreshTokenKey, data['session']['refresh_token']);
      await prefs.setString(userKey, jsonEncode(data['user']));

      return data;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['detail'] ?? 'Login failed');
    }
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);

    if (token != null) {
      try {
        await http.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'token': token}),
        );
      } catch (e) {
        print('Error during logout: $e');
      }
    }

    // Clear stored data regardless of API success
    await prefs.remove(tokenKey);
    await prefs.remove(refreshTokenKey);
    await prefs.remove(userKey);
  }

  // Get current user data
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(userKey);

    if (userData != null) {
      return jsonDecode(userData);
    }
    return null;
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey) != null;
  }

  // Google sign-in URL
  Future<String> getGoogleAuthUrl() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/google/url'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['url'];
    } else {
      throw Exception('Failed to get Google auth URL');
    }
  }

  // Add a helper method to get auth headers
  Future<Map<String, String>> getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
