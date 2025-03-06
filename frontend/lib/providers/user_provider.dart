// frontend/lib/providers/user_provider.dart

import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  UserProvider() {
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userData = await _authService.getCurrentUser();
      if (userData != null) {
        _user = User.fromJson(userData);
      }
    } catch (e) {
      print('Error loading user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(
      {String? email, String? phone, required String password}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.login(
        email: email,
        phone: phone,
        password: password,
      );

      _user = User.fromJson(response['user']);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String fullName,
    String? email,
    String? phone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.register(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );

      // After registration, log in the user
      final response = await _authService.login(
        email: email,
        phone: phone,
        password: password,
      );

      _user = User.fromJson(response['user']);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _user = null;
    } catch (e) {
      print('Error during logout: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to update user data if needed
  void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
}
