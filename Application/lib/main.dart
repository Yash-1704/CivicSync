import 'package:flutter/material.dart';
import 'screens/auth/login_page.dart';

void main() {
  runApp(CivicSyncApp());
}

class CivicSyncApp extends StatelessWidget {
  const CivicSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CivicSync',
      theme: ThemeData(useMaterial3: true),
      home: LoginPage(),
    );
  }
}
