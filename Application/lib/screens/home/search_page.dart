// lib/pages/search_page.dart
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final scaffoldBg = theme.scaffoldBackgroundColor;
    final appBarBg = theme.appBarTheme.backgroundColor ?? colorScheme.surface;
    final cardColor = theme.cardColor ??
        (theme.brightness == Brightness.dark ? const Color.fromRGBO(255, 255, 255, 0.05) : Colors.white);

    final results = demoReports
        .where((r) => r["title"]!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: scaffoldBg == Colors.transparent ? colorScheme.background : scaffoldBg,
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface) ??
              TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: "Search reports...",
            hintStyle: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.6))
                ?? TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
            border: InputBorder.none,
          ),
          onChanged: (val) => setState(() => query = val),
        ),
        backgroundColor: appBarBg,
        iconTheme: theme.appBarTheme.iconTheme ?? theme.iconTheme,
        elevation: 0,
      ),
      body: query.isEmpty
          ? _buildTags(context)
          : results.isEmpty
              ? Center(
                  child: Text(
                    "No reports found",
                    style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.75))
                        ?? TextStyle(color: colorScheme.onSurface.withOpacity(0.75)),
                  ),
                )
              : ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final report = results[index];
                    return Card(
                      margin: const EdgeInsets.all(12),
                      color: cardColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(report["title"]!,
                            style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface) ??
                                TextStyle(color: colorScheme.onSurface)),
                        subtitle: Text(report["status"]!,
                            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.75)) ??
                                TextStyle(color: colorScheme.onSurface.withOpacity(0.75))),
                        leading: Icon(Icons.search, color: theme.iconTheme.color?.withOpacity(0.9)),
                      ),
                    );
                  },
                ),
    );
  }

  /// Builds clickable tags
  Widget _buildTags(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.onSurface.withOpacity(0.6)),
                color: Colors.transparent,
              ),
              child: Text(
                tag,
                style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface) ??
                    TextStyle(color: colorScheme.onSurface),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
