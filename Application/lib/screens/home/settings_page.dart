import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/../services/theme_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          backgroundColor: themeService.getPrimaryBackgroundColor(context),
          appBar: AppBar(
            title: const Text('Settings'),
            backgroundColor: themeService.getSecondaryBackgroundColor(context),
            foregroundColor: themeService.getPrimaryTextColor(context),
            elevation: 0,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: themeService.getBackgroundGradient(context),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Theme Section
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.palette,
                              color: themeService.getPrimaryAccentColor(context),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Appearance',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: themeService.getPrimaryTextColor(context),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Theme',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: themeService.getPrimaryTextColor(context),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Theme Options
                        _buildThemeOption(
                          context,
                          themeService,
                          AppThemeMode.light,
                          'Light Mode',
                          'Bright and clean interface',
                          Icons.light_mode,
                        ),
                        const SizedBox(height: 8),
                        _buildThemeOption(
                          context,
                          themeService,
                          AppThemeMode.dark,
                          'Dark Mode',
                          'Easy on the eyes in low light',
                          Icons.dark_mode,
                        ),
                        const SizedBox(height: 8),
                        _buildThemeOption(
                          context,
                          themeService,
                          AppThemeMode.system,
                          'System Default',
                          'Follow system theme setting',
                          Icons.settings_system_daydream,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // App Information Section
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: themeService.getPrimaryAccentColor(context),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'About',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: themeService.getPrimaryTextColor(context),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        _buildInfoItem(
                          context,
                          themeService,
                          'App Version',
                          '1.0.0',
                          Icons.apps,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoItem(
                          context,
                          themeService,
                          'Developer',
                          'CivicSync Team',
                          Icons.people,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoItem(
                          context,
                          themeService,
                          'Contact',
                          'support@civicsync.com',
                          Icons.email,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Additional Settings Section
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.settings,
                              color: themeService.getPrimaryAccentColor(context),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Preferences',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: themeService.getPrimaryTextColor(context),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        ListTile(
                          leading: Icon(
                            Icons.notifications,
                            color: themeService.getSecondaryTextColor(context),
                          ),
                          title: Text(
                            'Notifications',
                            style: TextStyle(
                              color: themeService.getPrimaryTextColor(context),
                            ),
                          ),
                          subtitle: Text(
                            'Manage notification preferences',
                            style: TextStyle(
                              color: themeService.getSecondaryTextColor(context),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeService.getSecondaryTextColor(context),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Notification settings coming soon!'),
                              ),
                            );
                          },
                        ),
                        
                        ListTile(
                          leading: Icon(
                            Icons.privacy_tip,
                            color: themeService.getSecondaryTextColor(context),
                          ),
                          title: Text(
                            'Privacy',
                            style: TextStyle(
                              color: themeService.getPrimaryTextColor(context),
                            ),
                          ),
                          subtitle: Text(
                            'Review privacy settings',
                            style: TextStyle(
                              color: themeService.getSecondaryTextColor(context),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeService.getSecondaryTextColor(context),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Privacy settings coming soon!'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeService themeService,
    AppThemeMode themeMode,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final bool isSelected = themeService.currentTheme == themeMode;
    
    return InkWell(
      onTap: () => themeService.setTheme(themeMode),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? themeService.getPrimaryAccentColor(context)
                : themeService.getSecondaryTextColor(context).withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? themeService.getPrimaryAccentColor(context).withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? themeService.getPrimaryAccentColor(context)
                  : themeService.getSecondaryTextColor(context),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? themeService.getPrimaryAccentColor(context)
                          : themeService.getPrimaryTextColor(context),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: themeService.getSecondaryTextColor(context),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: themeService.getPrimaryAccentColor(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    ThemeService themeService,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: themeService.getSecondaryTextColor(context),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: themeService.getPrimaryTextColor(context),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: themeService.getSecondaryTextColor(context),
          ),
        ),
      ],
    );
  }
}