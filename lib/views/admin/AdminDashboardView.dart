import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sup4_dev_trello/providers/auth_provider.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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
              'Bienvenue sur le tableau de bord de l\'administrateur',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to manage users screen
              },
              child: const Text('Gérer les utilisateurs'),
            ),
            ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/projects');
            },
            child: const Text('Gérer les projets'),
          ),

          ],
        ),
      ),
    );
  }
}
