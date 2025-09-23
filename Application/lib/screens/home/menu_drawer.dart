import 'package:flutter/material.dart';
import 'my_reports_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'extra/credits_page.dart';
import 'extra/refer_earn_page.dart';
import 'extra/terms_conditions.dart';
import 'package:provider/provider.dart';
import '/../services/theme_service.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: themeService.getBackgroundGradient(context),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        themeService.getSecondaryBackgroundColor(context),
                        themeService.getPrimaryBackgroundColor(context)
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: themeService.getPrimaryTextColor(context).withOpacity(0.24),
                        child: Icon(
                          Icons.person,
                          color: themeService.getPrimaryTextColor(context),
                          size: 32,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Welcome, User",
                        style: TextStyle(
                          color: themeService.getPrimaryTextColor(context),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "user@email.com",
                        style: TextStyle(
                          color: themeService.getSecondaryTextColor(context),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildDrawerItem(
                  context,
                  themeService,
                  Icons.home,
                  "Home",
                  () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context,
                  themeService,
                  Icons.list_alt,
                  "My Reports",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MyReportsPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  themeService,
                  Icons.person,
                  "Profile",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProfilePage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  themeService,
                  Icons.stars,
                  "Credits",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreditsPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  themeService,
                  Icons.people,
                  "Refer & Earn",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReferEarnPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  themeService,
                  Icons.settings,
                  "Settings",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SettingsPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  themeService,
                  Icons.description_outlined,
                  "Terms & Conditions",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TermsConditionsPage()),
                    );
                  },
                ),
                Divider(color: themeService.getSecondaryTextColor(context).withOpacity(0.24)),
                _buildDrawerItem(
                  context,
                  themeService,
                  Icons.logout,
                  "Sign Out",
                  () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Signed out")),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    ThemeService themeService,
    IconData icon,
    String text,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: themeService.getSecondaryTextColor(context)),
      title: Text(
        text,
        style: TextStyle(color: themeService.getPrimaryTextColor(context)),
      ),
      onTap: onTap,
    );
  }
}