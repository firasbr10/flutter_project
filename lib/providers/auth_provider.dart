import 'package:flutter/material.dart';
import 'package:sup4_dev_trello/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;

  AuthProvider() {
    _user = _authService.getCurrentUser();
  }

  // Connexion
  Future<void> login(String email, String password) async {
    _user = await _authService.login(email, password);
    notifyListeners();
  }

  // Inscription avec username
  Future<void> signup(String username, String email, String password) async {
    _user = await _authService.signup(username, email, password);
    notifyListeners();
  }

  // Déconnexion
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
