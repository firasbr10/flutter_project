import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:sup4_dev_trello/providers/auth_provider.dart';
import 'package:sup4_dev_trello/providers/project_provider.dart';

import 'package:sup4_dev_trello/views/auth/login_view.dart';
import 'package:sup4_dev_trello/views/auth/signup_view.dart';
import 'package:sup4_dev_trello/views/admin/admindashboardview.dart';
import 'package:sup4_dev_trello/views/dashboard/userdashboardview.dart';
import 'package:sup4_dev_trello/views/project/project_view.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  runApp(
    MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ProjectProvider()), 
  ],
  child: const MyApp(),
)

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUP4 DEV Trello',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login', // Toujours vers login, la redirection se fait ensuite
      routes: {
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignupView(),
        '/admin_dashboard': (context) => const AdminDashboardView(),
        '/user_dashboard': (context) => const UserDashboardView(),
        '/projects': (context) => const ProjectView(),

      },
    );
  }
}
