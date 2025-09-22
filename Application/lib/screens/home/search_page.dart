import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, dynamic>> demoReports = [
    {"title": "Pothole on Main Street", "status": "Pending"},
    {"title": "Streetlight not working", "status": "In Progress"},
    {"title": "Garbage Overflow", "status": "Resolved"},
    {"title": "Water leak near Block 12", "status": "Pending"},
    {"title": "Gas issue in Sector 7", "status": "In Progress"},
  ];

  String query = "";

  final List<String> tags = [
    "Latest",
    "Nearby",
    "High",
    "Pothole",
    "Water Leak",
    "Gas Issue",
    "Streetlight",
    "Garbage",
  ];

  void _onTagTap(String tag) {
    setState(() {
      query = tag;
      _controller.text = tag;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color darkA = const Color(0xFF0F172A);
    final Color darkB = const Color(0xFF312E81);

    final results = demoReports
        .where((r) => r["title"]!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: darkA,
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search reports...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (val) => setState(() => query = val),
        ),
        backgroundColor: darkB,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: query.isEmpty
          ? _buildTags()
          : results.isEmpty
              ? const Center(
                  child: Text(
                    "No reports found",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final report = results[index];
                    return Card(
                      margin: const EdgeInsets.all(12),
                      color: Colors.white.withOpacity(0.05),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(report["title"]!,
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(report["status"]!,
                            style: const TextStyle(color: Colors.white70)),
                        leading:
                            const Icon(Icons.search, color: Colors.white70),
                      ),
                    );
                  },
                ),
    );
  }

  /// Builds clickable tags
  Widget _buildTags() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: tags.map((tag) {
          return InkWell(
            onTap: () => _onTagTap(tag),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white70),
                color: Colors.transparent,
              ),
              child: Text(
                tag,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
