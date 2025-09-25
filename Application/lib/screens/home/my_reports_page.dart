// lib/pages/my_reports.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // <-- added


class MyReportsPage extends StatefulWidget {
  const MyReportsPage({super.key});

  @override
  State<MyReportsPage> createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  // Status colors (kept as constants for consistency across themes)
  final Map<String, Color> _statusColors = const {
    "Pending": Color(0xFFF7D154),
    "In Progress": Color(0xFF4DA1FF),
    "Resolved": Color(0xFF3AC47D),
  };

  Stream<QuerySnapshot<Map<String, dynamic>>>? _reportsStream;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _reportsStream = FirebaseFirestore.instance
          .collection('reports')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots();
    } else {
      _reportsStream = null;
    }
  }

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
      body: _buildBody(context, cardColor),
    );
  }

  Widget _buildBody(BuildContext context, Color cardColor) {
    final theme = Theme.of(context);

    // If user isn't signed in, show a message
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(
        child: Text(
          'Please sign in to view your reports.',
          style: theme.textTheme.titleMedium,
        ),
      );
    }

    if (_reportsStream == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _reportsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          // == REPLACED: show friendly UI + button to open Firebase Console index link if present ==
          final error = snapshot.error;
          String message = error.toString();

          // Try to extract the console link from the error message (if present).
          String? consoleUrl;
          try {
            final errMsg = (error is FirebaseException) ? (error.message ?? error.toString()) : error.toString();
            final match = RegExp(r'https?://console\.firebase\.google\.com[^\s]+').firstMatch(errMsg);
            if (match != null) consoleUrl = match.group(0);
          } catch (_) {
            consoleUrl = null;
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'There was an error loading reports.',
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  if (consoleUrl != null)
                    ElevatedButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse(consoleUrl!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          // fallback: open firebase console root
                          final root = Uri.parse('https://console.firebase.google.com/');
                          if (await canLaunchUrl(root)) {
                            await launchUrl(root, mode: LaunchMode.externalApplication);
                          }
                        }
                      },
                      icon: const Icon(Icons.link),
                      label: const Text('Open Firebase index URL'),
                    )
                  else
                    ElevatedButton(
                      onPressed: () async {
                        final root = Uri.parse('https://console.firebase.google.com/');
                        if (await canLaunchUrl(root)) {
                          await launchUrl(root, mode: LaunchMode.externalApplication);
                        }
                      },
                      child: const Text('Open Firebase console'),
                    ),
                ],
              ),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(
            child: Text(
              'You have not submitted any reports yet.',
              style: theme.textTheme.titleMedium,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data();

            // Safely extract fields with fallbacks
            final title = (data['description'] as String?) ?? 'Untitled Report';
            final address = (data['location'] as String?) ?? 'Unknown location';

            String imageUrl = '';
            try {
              final images = data['imageUrls'];
              if (images is List && images.isNotEmpty) {
                imageUrl = images.first as String;
              } else if (data['imageUrl'] is String) {
                imageUrl = data['imageUrl'] as String;
              }
            } catch (_) {
              imageUrl = '';
            }

            // Firestore stored statuses may be lowercase (e.g. 'pending') — normalize to Title Case
            String rawStatus = (data['status'] as String?) ?? 'pending';
            final status = _normalizeStatus(rawStatus);

            return _buildReportCard(
              context,
              title,
              address,
              imageUrl.isNotEmpty ? imageUrl : 'https://picsum.photos/200/200?random=${index}',
              status,
              cardColor,
            );
          },
        );
      },
    );
  }

  String _normalizeStatus(String s) {
    final lower = s.toLowerCase();
    switch (lower) {
      case 'pending':
        return 'Pending';
      case 'in progress':
      case 'in_progress':
      case 'inprogress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      default:
        // Capitalize first letter
        if (s.isEmpty) return 'Pending';
        return s[0].toUpperCase() + s.substring(1);
    }
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
