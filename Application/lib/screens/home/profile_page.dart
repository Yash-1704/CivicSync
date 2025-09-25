import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final scaffoldBg = theme.scaffoldBackgroundColor;
    final appBarBg = theme.appBarTheme.backgroundColor ?? colorScheme.surface;
    final surface = theme.cardColor ??
        (theme.brightness == Brightness.dark ? const Color.fromRGBO(255, 255, 255, 0.05) : Colors.white);

    return Scaffold(
      backgroundColor: scaffoldBg == Colors.transparent ? colorScheme.background : scaffoldBg,
      appBar: AppBar(
        title: Text('Profile', style: theme.textTheme.titleLarge),
        backgroundColor: appBarBg,
        foregroundColor: theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/images/profile.jpg'),
                backgroundColor: surface,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                FirebaseAuth.instance.currentUser?.email ?? "Username",
                style: theme.textTheme.headlineSmall?.copyWith(fontSize: 24, fontWeight: FontWeight.bold)
                    ?? TextStyle(color: colorScheme.onSurface, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                FirebaseAuth.instance.currentUser?.email ?? "user@example.com",
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.8))
                    ?? TextStyle(color: colorScheme.onSurface.withOpacity(0.8)),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Account'),
            const SizedBox(height: 8),
            _buildButton(context, 'Edit Profile', Icons.edit, onPressed: () {}),
            const SizedBox(height: 12),
            _buildButton(context, 'Change Password', Icons.lock, onPressed: () {}),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Settings'),
            const SizedBox(height: 8),
            _buildButton(context, 'Notification Preferences', Icons.notifications, onPressed: () {}),
            const SizedBox(height: 12),
            _buildButton(context, 'Privacy Settings', Icons.privacy_tip, onPressed: () {}),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text('Logout', style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSecondary, fontSize: 16)
                    ?? TextStyle(color: colorScheme.onSecondary, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Text(
      title,
      style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.75),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ) ??
          TextStyle(color: colorScheme.onSurface.withOpacity(0.75), fontWeight: FontWeight.bold, fontSize: 14),
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon, {required VoidCallback onPressed}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tileColor = theme.cardColor ??
        (theme.brightness == Brightness.dark ? const Color.fromRGBO(255, 255, 255, 0.05) : Colors.white);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.iconTheme.color?.withOpacity(0.9)),
            const SizedBox(width: 16),
            Text(label,
                style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withOpacity(0.9), fontSize: 16)
                    ?? TextStyle(color: colorScheme.onSurface.withOpacity(0.9), fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
