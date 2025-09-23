import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/../services/theme_service.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          backgroundColor: themeService.getPrimaryBackgroundColor(context),
          appBar: AppBar(
            title: const Text('Terms & Conditions'),
            backgroundColor: themeService.getSecondaryBackgroundColor(context),
            foregroundColor: themeService.getPrimaryTextColor(context),
            elevation: 0,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: themeService.getBackgroundGradient(context),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.description,
                                color: themeService.getPrimaryAccentColor(context),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Terms & Conditions',
                                      style: TextStyle(
                                        color: themeService.getPrimaryTextColor(context),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Last updated: January 2024',
                                      style: TextStyle(
                                        color: themeService.getSecondaryTextColor(context),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Please read these terms and conditions carefully before using the CivicSync application.',
                            style: TextStyle(
                              color: themeService.getSecondaryTextColor(context),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Terms Content
                  _buildTermsSection(
                    '1. Acceptance of Terms',
                    'By downloading, installing, or using the CivicSync application, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use our service.',
                    themeService,
                    context,
                  ),
                  
                  _buildTermsSection(
                    '2. Service Description',
                    'CivicSync is a civic engagement platform that allows users to report issues in their community, track the progress of reported issues, and earn credits for their contributions.',
                    themeService,
                    context,
                  ),
                  
                  _buildTermsSection(
                    '3. Credits System',
                    'CivicSync operates a credits system to reward user engagement. Credits are earned through verified issue reports and referrals. Credits have no monetary value and cannot be exchanged for cash.',
                    themeService,
                    context,
                  ),
                  
                  _buildTermsSection(
                    '4. User Responsibilities',
                    'Users are responsible for providing accurate information, not submitting false reports, respecting community guidelines, and maintaining account security.',
                    themeService,
                    context,
                  ),
                  
                  _buildTermsSection(
                    '5. Privacy and Data',
                    'Your privacy is important to us. We collect and use information as described in our Privacy Policy. By using CivicSync, you consent to our data practices.',
                    themeService,
                    context,
                  ),
                  
                  _buildTermsSection(
                    '6. Contact Information',
                    'If you have questions about these Terms and Conditions, please contact us at: support@civicsync.app',
                    themeService,
                    context,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Footer
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: themeService.getPrimaryAccentColor(context),
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Questions?',
                            style: TextStyle(
                              color: themeService.getPrimaryTextColor(context),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'If you have any questions about these terms, please contact our support team.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: themeService.getSecondaryTextColor(context),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Opening contact form...'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeService.getPrimaryAccentColor(context),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Contact Support'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTermsSection(String title, String content, ThemeService themeService, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withOpacity(0.03)
          : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: themeService.getPrimaryTextColor(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                color: themeService.getSecondaryTextColor(context),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}