import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../services/theme_service.dart';

class ReferEarnPage extends StatefulWidget {
  const ReferEarnPage({super.key});

  @override
  State<ReferEarnPage> createState() => _ReferEarnPageState();
}

class _ReferEarnPageState extends State<ReferEarnPage> {
  // Sample referral data
  final String _referralCode = 'CIVIC2024USER';
  final String _referralLink = 'https://civicsync.app/join?ref=CIVIC2024USER';
  final int _referralCredits = 100;
  final int _totalReferrals = 7;
  final int _pendingReferrals = 2;
  final int _completedReferrals = 5;
  
  final List<Map<String, dynamic>> _referralHistory = [
    {
      'id': '1',
      'name': 'John Doe',
      'status': 'completed',
      'date': '2024-01-20',
      'credits': 100,
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'status': 'completed',
      'date': '2024-01-18',
      'credits': 100,
    },
    {
      'id': '3',
      'name': 'Mike Johnson',
      'status': 'pending',
      'date': '2024-01-19',
      'credits': 0,
    },
    {
      'id': '4',
      'name': 'Sarah Wilson',
      'status': 'completed',
      'date': '2024-01-15',
      'credits': 100,
    },
    {
      'id': '5',
      'name': 'David Brown',
      'status': 'pending',
      'date': '2024-01-21',
      'credits': 0,
    },
  ];

  void _copyReferralLink() {
    Clipboard.setData(ClipboardData(text: _referralLink));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Referral link copied to clipboard!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _copyReferralCode() {
    Clipboard.setData(ClipboardData(text: _referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Referral code copied to clipboard!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareReferralLink() {
    // Here you would integrate with share package
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening share dialog...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          backgroundColor: themeService.getPrimaryBackgroundColor(context),
          appBar: AppBar(
            title: const Text('Refer & Earn'),
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
                  // Referral Overview Card
                  _buildReferralOverviewCard(themeService),
                  const SizedBox(height: 20),
                  
                  // How It Works Section
                  _buildHowItWorksCard(themeService),
                  const SizedBox(height: 20),
                  
                  // Referral Link Section
                  _buildReferralLinkCard(themeService),
                  const SizedBox(height: 20),
                  
                  // Referral Stats
                  _buildReferralStatsCard(themeService),
                  const SizedBox(height: 20),
                  
                  // Referral History
                  Text(
                    'Referral History',
                    style: TextStyle(
                      color: themeService.getPrimaryTextColor(context),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Referral History List
                  ..._referralHistory.map((referral) => _buildReferralHistoryItem(referral, themeService)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReferralOverviewCard(ThemeService themeService) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade400,
              Colors.teal.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.people,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Earn $_referralCredits Credits',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'For each friend who joins',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your friend gets 50 credits too when they sign up!',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorksCard(ThemeService themeService) {
    return Card(
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
            Text(
              'How It Works',
              style: TextStyle(
                color: themeService.getPrimaryTextColor(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildStepItem(
              '1',
              'Share Your Link',
              'Send your referral link to friends and family',
              Icons.share,
              themeService,
            ),
            const SizedBox(height: 12),
            _buildStepItem(
              '2',
              'Friend Signs Up',
              'Your friend downloads the app and creates an account',
              Icons.person_add,
              themeService,
            ),
            const SizedBox(height: 12),
            _buildStepItem(
              '3',
              'Earn Credits',
              'You both get credits when they verify their account',
              Icons.stars,
              themeService,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(
    String step,
    String title,
    String description,
    IconData icon,
    ThemeService themeService,
  ) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: themeService.getPrimaryAccentColor(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              step,
              style: TextStyle(
                color: themeService.getPrimaryAccentColor(context),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(icon, color: themeService.getPrimaryAccentColor(context), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: themeService.getPrimaryTextColor(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: themeService.getSecondaryTextColor(context),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReferralLinkCard(ThemeService themeService) {
    return Card(
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
            Text(
              'Your Referral Link',
              style: TextStyle(
                color: themeService.getPrimaryTextColor(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Referral Code
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: themeService.getSecondaryTextColor(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: themeService.getSecondaryTextColor(context).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.code,
                    color: themeService.getSecondaryTextColor(context),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Referral Code',
                          style: TextStyle(
                            color: themeService.getSecondaryTextColor(context),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _referralCode,
                          style: TextStyle(
                            color: themeService.getPrimaryTextColor(context),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _copyReferralCode,
                    icon: Icon(
                      Icons.copy,
                      color: themeService.getPrimaryAccentColor(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Referral Link
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: themeService.getSecondaryTextColor(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: themeService.getSecondaryTextColor(context).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.link,
                    color: themeService.getSecondaryTextColor(context),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Referral Link',
                          style: TextStyle(
                            color: themeService.getSecondaryTextColor(context),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _referralLink,
                          style: TextStyle(
                            color: themeService.getPrimaryTextColor(context),
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _copyReferralLink,
                    icon: Icon(
                      Icons.copy,
                      color: themeService.getPrimaryAccentColor(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Share Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _shareReferralLink,
                icon: const Icon(Icons.share),
                label: const Text('Share with Friends'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeService.getPrimaryAccentColor(context),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralStatsCard(ThemeService themeService) {
    return Card(
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
            Text(
              'Your Referral Stats',
              style: TextStyle(
                color: themeService.getPrimaryTextColor(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total',
                    _totalReferrals.toString(),
                    Icons.people,
                    Colors.blue,
                    themeService,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Completed',
                    _completedReferrals.toString(),
                    Icons.check_circle,
                    Colors.green,
                    themeService,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Pending',
                    _pendingReferrals.toString(),
                    Icons.pending,
                    Colors.orange,
                    themeService,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
    ThemeService themeService,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: themeService.getPrimaryTextColor(context),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: themeService.getSecondaryTextColor(context),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildReferralHistoryItem(Map<String, dynamic> referral, ThemeService themeService) {
    Color statusColor = referral['status'] == 'completed' ? Colors.green : Colors.orange;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withOpacity(0.03)
          : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(
            referral['status'] == 'completed' ? Icons.check : Icons.pending,
            color: statusColor,
            size: 20,
          ),
        ),
        title: Text(
          referral['name'],
          style: TextStyle(
            color: themeService.getPrimaryTextColor(context),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          referral['date'],
          style: TextStyle(
            color: themeService.getSecondaryTextColor(context),
            fontSize: 12,
          ),
        ),
        trailing: referral['status'] == 'completed'
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+${referral['credits']}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Pending',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
      ),
    );
  }
}