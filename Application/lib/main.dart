import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'package:provider/provider.dart';
import 'screens/auth/login_page.dart';
import 'screens/home/home_user.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final themeService = ThemeService();
  await themeService.loadTheme();
  runApp(CivicSyncApp(themeService: themeService));
}

class CivicSyncApp extends StatelessWidget {
  final ThemeService themeService;
  
  const CivicSyncApp({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: themeService,
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'CivicSync',
            theme: themeService.lightTheme,
            darkTheme: themeService.darkTheme,
            themeMode: themeService.themeMode,
            home: const AuthCheck(),
          );
        },
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return const HomeUser(); // Already logged in
    } else {
      return const LoginPage(); // Not logged in
    }
  }
}
