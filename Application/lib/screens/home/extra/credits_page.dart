import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/theme_service.dart';

class CreditsPage extends StatefulWidget {
  const CreditsPage({super.key});

  @override
  State<CreditsPage> createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  // Sample user credits data
  final int _totalCredits = 2850;
  final int _creditsThisMonth = 450;
  final int _creditsFromReports = 2100;
  final int _creditsFromReferrals = 750;
  
  final List<Map<String, dynamic>> _creditHistory = [
    {
      'id': '1',
      'title': 'Reported Pothole near Block 5',
      'credits': 50,
      'date': '2024-01-20',
      'type': 'report',
      'status': 'verified'
    },
    {
      'id': '2',
      'title': 'Friend joined via referral',
      'credits': 100,
      'date': '2024-01-19',
      'type': 'referral',
      'status': 'completed'
    },
    {
      'id': '3',
      'title': 'Reported Broken Streetlight',
      'credits': 75,
      'date': '2024-01-18',
      'type': 'report',
      'status': 'verified'
    },
    {
      'id': '4',
      'title': 'Issue Resolution Bonus',
      'credits': 25,
      'date': '2024-01-17',
      'type': 'bonus',
      'status': 'completed'
    },
    {
      'id': '5',
      'title': 'Reported Graffiti Issue',
      'credits': 40,
      'date': '2024-01-16',
      'type': 'report',
      'status': 'verified'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          backgroundColor: themeService.getPrimaryBackgroundColor(context),
          appBar: AppBar(
            title: const Text('My Credits'),
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
                  // Credits Overview Card
                  _buildCreditsOverviewCard(themeService),
                  const SizedBox(height: 20),
                  
                  // Credits Breakdown
                  _buildCreditsBreakdown(themeService),
                  const SizedBox(height: 20),
                  
                  // Recent Credits History
                  Text(
                    'Recent Activity',
                    style: TextStyle(
                      color: themeService.getPrimaryTextColor(context),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Credits History List
                  ..._creditHistory.map((credit) => _buildCreditHistoryItem(credit, themeService)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCreditsOverviewCard(ThemeService themeService) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeService.getPrimaryAccentColor(context),
              themeService.getSecondaryAccentColor(context),
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
                  Icons.stars,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Credits',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '$_totalCredits',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '+$_creditsThisMonth this month',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Credits can be redeemed for rewards and benefits',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
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

  Widget _buildCreditsBreakdown(ThemeService themeService) {
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
              'Credits Breakdown',
              style: TextStyle(
                color: themeService.getPrimaryTextColor(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildBreakdownItem(
              Icons.report_problem,
              'From Reports',
              _creditsFromReports,
              Colors.orange,
              themeService,
            ),
            const SizedBox(height: 12),
            _buildBreakdownItem(
              Icons.people,
              'From Referrals',
              _creditsFromReferrals,
              Colors.green,
              themeService,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownItem(
    IconData icon,
    String title,
    int credits,
    Color color,
    ThemeService themeService,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: themeService.getPrimaryTextColor(context),
              fontSize: 14,
            ),
          ),
        ),
        Text(
          '$credits',
          style: TextStyle(
            color: themeService.getPrimaryTextColor(context),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCreditHistoryItem(Map<String, dynamic> credit, ThemeService themeService) {
    IconData icon;
    Color iconColor;
    
    switch (credit['type']) {
      case 'report':
        icon = Icons.report_problem;
        iconColor = Colors.orange;
        break;
      case 'referral':
        icon = Icons.people;
        iconColor = Colors.green;
        break;
      case 'bonus':
        icon = Icons.star;
        iconColor = Colors.purple;
        break;
      default:
        icon = Icons.star;
        iconColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withOpacity(0.03)
          : Colors.white,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          credit['title'],
          style: TextStyle(
            color: themeService.getPrimaryTextColor(context),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          credit['date'],
          style: TextStyle(
            color: themeService.getSecondaryTextColor(context),
            fontSize: 12,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '+${credit['credits']}',
            style: const TextStyle(
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}