import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sup4_dev_trello/providers/auth_provider.dart';

class UserDashboardView extends StatelessWidget {
  const UserDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenue sur votre tableau de bord utilisateur',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to view tasks or projects screen
              },
              child: const Text('Voir mes projets'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to view activities screen
              },
              child: const Text('Voir mes activités'),
            ),
          ],
        ),
      ),
    );
  }
}
