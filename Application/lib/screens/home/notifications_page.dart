// lib/pages/notifications_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [
    {
      "title": "Report Resolved",
      "desc": "Your report on garbage overflow was marked as resolved.",
      "time": "2h ago",
      "imageUrl": "https://picsum.photos/seed/garbage/400/200",
      "status": "Resolved",
      "seen": false,
    },
    {
      "title": "Report Acknowledged",
      "desc": "Pothole near Block 3 has been acknowledged by the authorities.",
      "time": "5h ago",
      "imageUrl": "https://picsum.photos/seed/pothole/400/200",
      "status": "In Progress",
      "seen": true,
    },
    {
      "title": "Update",
      "desc": "Streetlight repair scheduled for Sector 7 tomorrow.",
      "time": "1d ago",
      "imageUrl": "https://picsum.photos/seed/streetlight/400/200",
      "status": "Pending",
      "seen": false,
    },
  ];

  final Map<String, Color> statusColors = {
    "Pending": Colors.yellow,
    "In Progress": Colors.blue,
    "Resolved": Colors.green,
  };

  void _showNotificationCard(int index) {
    setState(() {
      notifications[index]["seen"] = true;
    });

    final notif = notifications[index];
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dialogBg = colorScheme.surface;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Dialog(
            backgroundColor: dialogBg, // fully opaque surface (theme-aware)
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      notif["imageUrl"],
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 180,
                        color: theme.dividerColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    notif["title"],
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
                        ?? TextStyle(color: colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notif["desc"],
                    style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.85))
                        ?? TextStyle(color: colorScheme.onSurface.withOpacity(0.85), fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: (statusColors[notif["status"]] ?? Colors.white).withOpacity(0.18),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (statusColors[notif["status"]] ?? Colors.white).withOpacity(0.28),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: statusColors[notif["status"]],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              notif["status"],
                              style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ) ??
                                  TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        notif["time"],
                        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))
                            ?? TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.appBarTheme.backgroundColor ?? colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text("Close", style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onPrimary)),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final scaffoldBg = theme.scaffoldBackgroundColor;
    final appBarBg = theme.appBarTheme.backgroundColor ?? colorScheme.surface;
    final cardColor = theme.cardColor ??
        (theme.brightness == Brightness.dark ? const Color.fromRGBO(255, 255, 255, 0.03) : Colors.white);

    return Scaffold(
      backgroundColor: scaffoldBg == Colors.transparent ? colorScheme.background : scaffoldBg,
      appBar: AppBar(
        title: Text("Notifications", style: theme.textTheme.titleLarge),
        backgroundColor: appBarBg,
        iconTheme: theme.appBarTheme.iconTheme ?? theme.iconTheme,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Stack(
            children: [
              GestureDetector(
                onTap: () => _showNotificationCard(index),
                child: Card(
                  color: cardColor,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        notif["imageUrl"],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 50,
                          height: 50,
                          color: theme.dividerColor,
                        ),
                      ),
                    ),
                    title: Text(
                      notif["title"],
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)
                          ?? TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      notif["desc"],
                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.8))
                          ?? TextStyle(color: colorScheme.onSurface.withOpacity(0.8)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      notif["time"],
                      style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.65))
                          ?? TextStyle(color: colorScheme.onSurface.withOpacity(0.65), fontSize: 12),
                    ),
                  ),
                ),
              ),
              if (notif["seen"] == false)
                const Positioned(
                  right: 16,
                  top: 16,
                  child: _UnreadDot(),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _UnreadDot extends StatelessWidget {
  const _UnreadDot({super.key});
  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: errorColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
