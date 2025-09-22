import 'package:flutter/material.dart';

class MapsPage extends StatelessWidget {
  final Color darkA = const Color(0xFF0F172A);
  final Color darkB = const Color(0xFF312E81);
  final Color accent = const Color(0xFF3B82F6);

  final List<Map<String, dynamic>> sampleMarkers = [
    {"title": "Pothole near Block 5", "status": "Pending", "distance": "0.8 km"},
    {"title": "Broken Streetlight", "status": "In Progress", "distance": "1.2 km"},
    {"title": "Graffiti Cleaned", "status": "Resolved", "distance": "2.5 km"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkA,
      appBar: AppBar(
        title: const Text("City Map"),
        backgroundColor: darkB,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Map placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              "https://picsum.photos/800/300?map",
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),

          // Section header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Nearby Issues",
                style: TextStyle(
                  color: Colors.white,
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
                  color: Colors.white.withOpacity(0.05),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: accent.withOpacity(0.7),
                      child: const Icon(Icons.location_on, color: Colors.white),
                    ),
                    title: Text(
                      marker["title"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "${marker["status"]} • ${marker["distance"]}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.white54),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
