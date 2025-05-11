import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Inscription avec username, email et mot de passe
  Future<User?> signup(String username, String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ajouter le username et le rôle dans Firestore
      if (userCredential.user != null) {
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'username': username,
          'email': email,
          'role': 'user',  // Rôle par défaut
        });
      }
      return userCredential.user;
    } catch (e) {
      print('Error during signup: $e');
      return null;
    }
  }

  // Connexion
  Future<User?> login(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  // Déconnexion
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Vérification de l'utilisateur actuel
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
