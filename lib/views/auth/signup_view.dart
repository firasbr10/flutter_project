import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sup4_dev_trello/providers/auth_provider.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;
  String _role = 'utilisateur'; // Rôle par défaut

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            // Champ pour choisir le rôle (visible uniquement pour l'admin)
            if (authProvider.user != null && authProvider.role == 'admin') 
              DropdownButton<String>(
                value: _role,
                onChanged: (String? newValue) {
                  setState(() {
                    _role = newValue!;
                  });
                },
                items: <String>['utilisateur', 'admin']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                        _error = null;
                      });

                      await authProvider
                          .signup(
                            _usernameController.text.trim(),
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            _role, // Passer le rôle sélectionné
                          )
                          .then((_) {
                        if (authProvider.user != null) {
                          // Vérifier le rôle et rediriger en fonction du rôle
                          String? role = authProvider.role; // Récupérer le rôle
                          if (role == 'admin') {
                            // Rediriger vers le dashboard admin
                            Navigator.pushReplacementNamed(context, '/admin_dashboard');
                          } else {
                            // Rediriger vers le dashboard utilisateur
                            Navigator.pushReplacementNamed(context, '/user_dashboard');
                          }
                        } else {
                          setState(() {
                            _error = 'Erreur lors de l\'inscription';
                          });
                        }
                      });

                      setState(() {
                        _loading = false;
                      });
                    },
                    child: const Text('S\'inscrire'),
                  ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Déjà un compte ? Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
