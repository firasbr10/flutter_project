import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sup4_dev_trello/providers/auth_provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
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

                      try {
                        await authProvider.login(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );

                        final user = authProvider.user;
                        final role = authProvider.role;

                        if (user != null && role != null) {
                          if (role == 'admin') {
                            Navigator.pushReplacementNamed(context, '/admin_dashboard');
                          } else {
                            Navigator.pushReplacementNamed(context, '/user_dashboard');
                          }
                        } else {
                          setState(() {
                            _error = 'Identifiants invalides ou rôle non défini.';
                          });
                        }
                      } catch (e) {
                        setState(() {
                          _error = 'Erreur lors de la connexion.';
                        });
                      }

                      setState(() {
                        _loading = false;
                      });
                    },
                    child: const Text('Connexion'),
                  ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}
