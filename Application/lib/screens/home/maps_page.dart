import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/../services/theme_service.dart';

class MapsPage extends StatelessWidget {
  final List<Map<String, dynamic>> sampleMarkers = [
    {"title": "Pothole near Block 5", "status": "Pending", "distance": "0.8 km"},
    {"title": "Broken Streetlight", "status": "In Progress", "distance": "1.2 km"},
    {"title": "Graffiti Cleaned", "status": "Resolved", "distance": "2.5 km"},
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          backgroundColor: themeService.getPrimaryBackgroundColor(context),
          appBar: AppBar(
            title: const Text("City Map"),
            backgroundColor: themeService.getSecondaryBackgroundColor(context),
            foregroundColor: themeService.getPrimaryTextColor(context),
            elevation: 0,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: themeService.getBackgroundGradient(context),
            ),
            child: Column(
              children: [
                // Map placeholder
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://picsum.photos/800/300?map",
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Section header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Nearby Issues",
                      style: TextStyle(
                        color: themeService.getPrimaryTextColor(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Marker list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: sampleMarkers.length,
                    itemBuilder: (context, index) {
                      final marker = sampleMarkers[index];
                      return Card(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: themeService.getPrimaryAccentColor(context).withOpacity(0.7),
                            child: const Icon(Icons.location_on, color: Colors.white),
                          ),
                          title: Text(
                            marker["title"],
                            style: TextStyle(
                              color: themeService.getPrimaryTextColor(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            "${marker["status"]} • ${marker["distance"]}",
                            style: TextStyle(
                              color: themeService.getSecondaryTextColor(context),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: themeService.getSecondaryTextColor(context),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
