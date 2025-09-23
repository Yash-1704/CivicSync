import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_page.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
            home: LoginPage(),
          );
        },
      ),
    );
  }
}
