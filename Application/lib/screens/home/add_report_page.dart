// lib/screens/home/add_report_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/../services/theme_service.dart';

class AddReportPage extends StatefulWidget {
  const AddReportPage({super.key});

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  final List<String> _tags = [
    'Pothole',
    'Water Leak',
    'Gas Issue',
    'Street Light',
    'Blocked Drain',
    'Noise Complaint',
    'Illegal Dumping',
    'Public Safety',
    'others',
  ];

  final Set<String> _selectedTags = {};

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          backgroundColor: themeService.getPrimaryBackgroundColor(context),
          appBar: AppBar(
            title: const Text('Add Report'),
            foregroundColor: themeService.getPrimaryTextColor(context),
            backgroundColor: themeService.getSecondaryBackgroundColor(context),
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
                  // Add Images / Videos Section
                  Text(
                    'Add Images / Short Video',
                    style: TextStyle(
                      color: themeService.getPrimaryTextColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showMediaOptions(context, themeService),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: themeService.getSecondaryTextColor(context).withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              color: themeService.getSecondaryTextColor(context),
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add Images or Short Video',
                              style: TextStyle(
                                color: themeService.getSecondaryTextColor(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Record Audio Section
                  Text(
                    'Record Audio',
                    style: TextStyle(
                      color: themeService.getPrimaryTextColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _recordAudio(),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: themeService.getSecondaryTextColor(context).withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mic,
                              color: themeService.getSecondaryTextColor(context),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Record Audio',
                              style: TextStyle(
                                color: themeService.getSecondaryTextColor(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Location Section
                  Text(
                    'Location',
                    style: TextStyle(
                      color: themeService.getPrimaryTextColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _locationController,
                    style: TextStyle(color: themeService.getPrimaryTextColor(context)),
                    decoration: InputDecoration(
                      hintText: 'Enter location',
                      hintStyle: TextStyle(
                        color: themeService.getSecondaryTextColor(context).withOpacity(0.5),
                      ),
                      suffixIcon: Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: themeService.getSecondaryTextColor(context).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          onPressed: _addCurrentLocation,
                          child: Text(
                            'Add Current Location',
                            style: TextStyle(
                              color: themeService.getPrimaryTextColor(context),
                            ),
                          ),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeService.getSecondaryTextColor(context).withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeService.getSecondaryTextColor(context).withOpacity(0.6),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tags Section
                  Text(
                    'Tags',
                    style: TextStyle(
                      color: themeService.getPrimaryTextColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _tags.map((tag) {
                      final selected = _selectedTags.contains(tag);
                      return GestureDetector(
                        onTap: () => _toggleTag(tag),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? themeService.getPrimaryTextColor(context).withOpacity(0.2)
                                : Colors.transparent,
                            border: Border.all(color: themeService.getPrimaryTextColor(context)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: themeService.getPrimaryTextColor(context),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Description Section
                  Text(
                    'Description',
                    style: TextStyle(
                      color: themeService.getPrimaryTextColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    style: TextStyle(color: themeService.getPrimaryTextColor(context)),
                    decoration: InputDecoration(
                      hintText: 'Describe the issue here...',
                      hintStyle: TextStyle(
                        color: themeService.getSecondaryTextColor(context).withOpacity(0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeService.getSecondaryTextColor(context).withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeService.getSecondaryTextColor(context).withOpacity(0.6),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeService.getSecondaryAccentColor(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Submit Report',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
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

  void _showMediaOptions(BuildContext context, ThemeService themeService) {
    showModalBottomSheet(
      backgroundColor: themeService.getPrimaryBackgroundColor(context),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: themeService.getPrimaryTextColor(context),
              ),
              title: Text(
                'Open Camera',
                style: TextStyle(
                  color: themeService.getPrimaryTextColor(context),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Camera integration
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library,
                color: themeService.getPrimaryTextColor(context),
              ),
              title: Text(
                'Open Gallery',
                style: TextStyle(
                  color: themeService.getPrimaryTextColor(context),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Gallery integration
              },
            ),
            ListTile(
              leading: Icon(
                Icons.videocam,
                color: themeService.getPrimaryTextColor(context),
              ),
              title: Text(
                'Record Short Video',
                style: TextStyle(
                  color: themeService.getPrimaryTextColor(context),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Video recording integration
              },
            ),
          ],
        );
      },
    );
  }

  void _recordAudio() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Audio recording feature coming soon!')),
    );
    // TODO: Implement audio recording
  }

  void _addCurrentLocation() {
    setState(() {
      _locationController.text = "123 Main St, Springfield"; // placeholder
    });
  }

  void _submitReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report submitted!')),
    );
    _locationController.clear();
    _descriptionController.clear();
    _selectedTags.clear();
  }
}
