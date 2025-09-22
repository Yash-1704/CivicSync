import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark background
      appBar: AppBar(
        title: const Text('Profile'),foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF312E81), // Accent color matching top app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile.jpg'), // Add a default image in assets
                backgroundColor: Colors.white24,
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Username',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'user@example.com',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Account'),
            const SizedBox(height: 8),
            _buildButton(context, 'Edit Profile', Icons.edit, onPressed: () {
              // Navigate to edit profile or open form
            }),
            const SizedBox(height: 12),
            _buildButton(context, 'Change Password', Icons.lock, onPressed: () {
              // Navigate to change password page
            }),
            const SizedBox(height: 24),
            _buildSectionTitle('Settings'),
            const SizedBox(height: 8),
            _buildButton(context, 'Notification Preferences', Icons.notifications, onPressed: () {
              // Open notification settings
            }),
            const SizedBox(height: 12),
            _buildButton(context, 'Privacy Settings', Icons.privacy_tip, onPressed: () {
              // Open privacy settings
            }),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Perform logout
                  Navigator.pop(context); // Example behavior
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D28D9), // Purple accent
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Logout', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14),
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon, {required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
