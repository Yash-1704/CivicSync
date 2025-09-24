// lib/pages/my_reports.dart
import 'package:flutter/material.dart';

class MyReportsPage extends StatelessWidget {
  MyReportsPage({super.key});

  // Status colors (kept as constants for consistency across themes)
  final Map<String, Color> _statusColors = const {
    "Pending": Color(0xFFF7D154),
    "In Progress": Color(0xFF4DA1FF),
    "Resolved": Color(0xFF3AC47D),
  };

  final List<Map<String, dynamic>> _reports = [
    {
      "title": "Pothole on Main Street",
      "address": "Main St & 5th Ave",
      "image": "https://picsum.photos/200/200?1",
      "status": "Pending",
    },
    {
      "title": "Broken Streetlight",
      "address": "Oak Park, Block 200",
      "image": "https://picsum.photos/200/200?2",
      "status": "In Progress",
    },
    {
      "title": "Graffiti on Public Building",
      "address": "City Hall, North Wall",
      "image": "https://picsum.photos/200/200?3",
      "status": "Resolved",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Respect ThemeData values and only fallback to safe defaults
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final appBarBg = theme.appBarTheme.backgroundColor ?? colorScheme.surface;

    // Use Theme's cardColor (recommended) and provide a sensible fallback per brightness
    final cardColor = theme.cardColor ??
        (theme.brightness == Brightness.dark
            ? const Color.fromRGBO(255, 255, 255, 0.03)
            : Colors.white);

    return Scaffold(
      backgroundColor: scaffoldBg == Colors.transparent ? colorScheme.background : scaffoldBg,
      appBar: AppBar(
        title: Text(
          "My Reports",
          style: theme.textTheme.titleLarge,
        ),
        backgroundColor: appBarBg,
        foregroundColor: theme.appBarTheme.foregroundColor ?? colorScheme.onSurface,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final report = _reports[index];
          return _buildReportCard(
            context,
            report["title"],
            report["address"],
            report["image"],
            report["status"],
            cardColor,
          );
        },
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    String title,
    String address,
    String imageUrl,
    String status,
    Color cardColor,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final int activeStep = _statusToIndex(status);
    final Color statusColor = _statusColors[status] ?? colorScheme.onSurface.withOpacity(0.7);

    // Text styles drawn from theme with sensible fallbacks
    final titleStyle = theme.textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600) ??
        TextStyle(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w600);
    final addressStyle = theme.textTheme.bodyMedium?.copyWith(fontSize: 13) ??
        TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 13);
    final chipTextStyle = theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600) ??
        TextStyle(color: colorScheme.onSurface.withOpacity(0.8), fontWeight: FontWeight.w600);

    return Card(
      color: cardColor,
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row (image + text)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 60,
                      height: 60,
                      color: theme.dividerColor, // theme-aware fallback
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: titleStyle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address,
                        style: addressStyle,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_vert, color: theme.iconTheme.color),
              ],
            ),
            const SizedBox(height: 16),

            // Progress tracker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStep(context, "Pending", 0, activeStep, _statusColors["Pending"]!),
                Expanded(
                  child: Divider(
                    color: activeStep >= 1 ? _statusColors["In Progress"] : theme.dividerColor,
                    thickness: 2,
                  ),
                ),
                _buildStep(context, "In Progress", 1, activeStep, _statusColors["In Progress"]!),
                Expanded(
                  child: Divider(
                    color: activeStep == 2 ? _statusColors["Resolved"] : theme.dividerColor,
                    thickness: 2,
                  ),
                ),
                _buildStep(context, "Resolved", 2, activeStep, _statusColors["Resolved"]!),
              ],
            ),

            const SizedBox(height: 12),

            // Status chip + Review button (if Resolved)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.28)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        status,
                        style: chipTextStyle.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.9)),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (status == "Resolved")
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(Icons.rate_review, size: 16, color: theme.colorScheme.onPrimary),
                    label: Text(
                      "Review",
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary) ??
                          TextStyle(color: theme.colorScheme.onPrimary),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _statusToIndex(String status) {
    switch (status) {
      case "Pending":
        return 0;
      case "In Progress":
        return 1;
      case "Resolved":
        return 2;
      default:
        return 0;
    }
  }

  Widget _buildStep(BuildContext context, String label, int index, int activeStep, Color activeColor) {
    final theme = Theme.of(context);
    final bool isActive = index <= activeStep;

    final textColor = isActive ? activeColor : theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? theme.colorScheme.onSurface.withOpacity(0.7);

    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isActive ? activeColor : theme.dividerColor,
          child: Icon(Icons.check, size: 14, color: isActive ? Colors.white : theme.iconTheme.color?.withOpacity(0.6)),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor,
          ),
        )
      ],
    );
  }
}
