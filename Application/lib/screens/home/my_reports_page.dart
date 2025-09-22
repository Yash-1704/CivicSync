import 'package:flutter/material.dart';

class MyReportsPage extends StatelessWidget {
  final Color darkA = const Color(0xFF0F172A);
  final Color darkB = const Color(0xFF312E81);
  final Color accent = const Color(0xFF3B82F6);
  final Color accent2 = const Color(0xFF6D28D9);

  final Map<String, Color> statusColors = const {
    "Pending": Color(0xFFF7D154),
    "In Progress": Color(0xFF4DA1FF),
    "Resolved": Color(0xFF3AC47D),
  };

  final List<Map<String, dynamic>> reports = [
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
    return Scaffold(
      backgroundColor: darkA,
      appBar: AppBar(
        title: const Text("My Reports"),foregroundColor:Colors.white,
        backgroundColor: darkB,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return _buildReportCard(
            report["title"],
            report["address"],
            report["image"],
            report["status"],
          );
        },
      ),
    );
  }

  Widget _buildReportCard(
    String title,
    String address,
    String imageUrl,
    String status,
  ) {
    final int activeStep = _statusToIndex(status);
    final Color statusColor = statusColors[status] ?? Colors.white70;

    return Card(
      color: Colors.white.withOpacity(0.03),
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
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert, color: Colors.white70),
              ],
            ),
            const SizedBox(height: 16),

            // Progress tracker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStep("Pending", 0, activeStep, statusColors["Pending"]!),
                Expanded(
                  child: Divider(
                    color: activeStep >= 1
                        ? statusColors["In Progress"]
                        : Colors.white24,
                    thickness: 2,
                  ),
                ),
                _buildStep(
                    "In Progress", 1, activeStep, statusColors["In Progress"]!),
                Expanded(
                  child: Divider(
                    color: activeStep == 2
                        ? statusColors["Resolved"]
                        : Colors.white24,
                    thickness: 2,
                  ),
                ),
                _buildStep("Resolved", 2, activeStep, statusColors["Resolved"]!),
              ],
            ),

            const SizedBox(height: 12),

            // Status chip + Review button (if Resolved)
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (status == "Resolved")
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.rate_review, size: 16),
                    label: const Text("Review"),
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

  Widget _buildStep(
      String label, int index, int activeStep, Color activeColor) {
    final bool isActive = index <= activeStep;
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isActive ? activeColor : Colors.white24,
          child: Icon(Icons.check,
              size: 14, color: isActive ? Colors.white : Colors.white38),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? activeColor : Colors.white54,
          ),
        )
      ],
    );
  }
}
