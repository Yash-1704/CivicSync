import 'package:flutter/material.dart';
import 'my_reports_page.dart';
import 'profile_page.dart';
// import 'settings_page.dart';

class MenuDrawer extends StatelessWidget {
  final Color darkA = const Color(0xFF0F172A);
  final Color darkB = const Color(0xFF312E81);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [darkA, darkB],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [darkB, darkA]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white, size: 32),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Welcome, User",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "user@email.com",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.home, "Home", () {
              Navigator.pop(context);
            }),
            _buildDrawerItem(Icons.list_alt, "My Reports", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MyReportsPage()),
              );
            }),
            _buildDrawerItem(Icons.person, "Profile", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage()),
              );
            }),
            // _buildDrawerItem(Icons.settings, "Settings", () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (_) => SettingsPage()),
            //   );
            // }),
            const Divider(color: Colors.white24),
            _buildDrawerItem(Icons.logout, "Sign Out", () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Signed out")),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}
