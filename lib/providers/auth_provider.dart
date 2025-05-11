import 'package:flutter/material.dart';
import 'package:sup4_dev_trello/models/user_model.dart';
import 'package:sup4_dev_trello/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  String? _role;

  User? get user => _user;
  String? get role => _role;

  AuthProvider() {
    _user = _authService.getCurrentUser();
  }

  Future<List<UserModel>> fetchAllUsers() async {
  final snapshot = await FirebaseFirestore.instance.collection('users').get();
  return snapshot.docs
      .map((doc) => UserModel.fromMap(doc.data()))
      .toList();
}


  // Connexion
  Future<void> login(String email, String password) async {
    _user = await _authService.login(email, password);

    if (_user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
      _role = userDoc['role']; // Récupérer le rôle de l'utilisateur
      notifyListeners();
    }
  }

  // Inscription avec rôle
  Future<void> signup(String username, String email, String password, String role) async {
    _user = await _authService.signup(username, email, password);

    if (_user != null) {
      // Ajouter le rôle dans Firestore
      await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
        'username': username,
        'email': email,
        'role': role, // Attribuer le rôle ici
      });

      // Récupérer le rôle de l'utilisateur depuis Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
      _role = userDoc['role'];

      notifyListeners();
    }
  }

  // Déconnexion
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _role = null;
    notifyListeners();
  }
}
