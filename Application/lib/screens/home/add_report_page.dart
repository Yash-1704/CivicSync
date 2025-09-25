// lib/screens/home/add_report_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '/../services/theme_service.dart';

// NEW: Cloudinary + Report services
import '../../services/cloudinary_service.dart';
import '../../services/report_service.dart';

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
  final ImagePicker _picker = ImagePicker();
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  List<File> _selectedImages = [];
  String? _audioPath;
  bool _isRecording = false;
  bool _isRecorderInitialized = false;
  bool _isPlayerInitialized = false;
  bool _isPlaying = false;

  // NEW: submission state
  bool _isSubmitting = false;

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    await _recorder!.openRecorder();
    await _player!.openPlayer();
    setState(() {
      _isRecorderInitialized = true;
      _isPlayerInitialized = true;
    });
  }

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
    if (_recorder != null) {
      _recorder!.closeRecorder();
    }
    if (_player != null) {
      _player!.closePlayer();
    }
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
                      child: _selectedImages.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: GestureDetector(
                                onTap: () => _showImagePreview(context),
                                child: Stack(
                                  children: [
                                    Image.file(
                                      _selectedImages.first,
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                    if (_selectedImages.length > 1)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '+${_selectedImages.length - 1}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedImages.clear();
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Center(
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
                    onTap: () => _isRecorderInitialized ? (_isRecording ? _stopRecording() : _startRecording()) : null,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: _isRecording 
                            ? Colors.red.withOpacity(0.2)
                            : (_audioPath != null 
                                ? Colors.green.withOpacity(0.2)
                                : Colors.transparent),
                        border: Border.all(
                          color: _isRecording 
                              ? Colors.red
                              : (_audioPath != null 
                                  ? Colors.green
                                  : themeService.getSecondaryTextColor(context).withOpacity(0.3)),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isRecording ? Icons.stop : (_audioPath != null ? Icons.check_circle : Icons.mic),
                              color: _isRecording 
                                  ? Colors.red
                                  : (_audioPath != null 
                                      ? Colors.green
                                      : themeService.getSecondaryTextColor(context)),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isRecording 
                                  ? 'Stop Recording'
                                  : (_audioPath != null 
                                      ? 'Audio Recorded'
                                      : 'Record Audio'),
                              style: TextStyle(
                                color: _isRecording 
                                    ? Colors.red
                                    : (_audioPath != null 
                                        ? Colors.green
                                        : themeService.getSecondaryTextColor(context)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Audio Playback Controls (show only when audio is recorded)
                  if (_audioPath != null && !_isRecording) 
                    const SizedBox(height: 12),
                  if (_audioPath != null && !_isRecording)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: _isPlayerInitialized ? (_isPlaying ? _pauseAudio : _playAudio) : null,
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.green,
                              size: 28,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _isPlaying ? 'Playing audio...' : 'Tap to replay audio',
                              style: TextStyle(
                                color: themeService.getPrimaryTextColor(context),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _audioPath = null;
                                _isPlaying = false;
                              });
                              if (_isPlaying) {
                                _player?.stopPlayer();
                              }
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Debug: Show if audio path exists but controls are hidden
                  if (_audioPath != null && _isRecording)
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Debug: Audio path exists: $_audioPath, Recording: $_isRecording',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
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
                      child: _isSubmitting
                          ? SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.white),
                            )
                          : const Text(
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
                _openCamera();
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
                _openGallery();
              },
            ),
          ],
        );
      },
    );
  }



  Future<void> _openCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      
      if (photo != null) {
        setState(() {
          _selectedImages.add(File(photo.path));
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo captured successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening camera: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      
      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image selected successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening gallery: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission is required'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      if (_recorder != null && _isRecorderInitialized) {
        final String path = '/data/data/com.example.civicsync/cache/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
        
        await _recorder!.startRecorder(
          toFile: path,
          codec: Codec.aacADTS,
        );
        
        setState(() {
          _isRecording = true;
          _audioPath = null;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recording started...'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting recording: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      if (_recorder != null && _isRecording) {
        final path = await _recorder!.stopRecorder();
        
        setState(() {
          _isRecording = false;
          _audioPath = path;
        });
        
        print('Audio recorded successfully. Path: $path'); // Debug print
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recording saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error stopping recording: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _playAudio() async {
    try {
      if (_player != null && _audioPath != null && _isPlayerInitialized) {
        await _player!.startPlayer(
          fromURI: _audioPath!,
          codec: Codec.aacADTS,
        );
        
        setState(() {
          _isPlaying = true;
        });
        
        // Listen for when playback finishes
        _player!.onProgress!.listen((e) {
          if (e.position >= e.duration) {
            setState(() {
              _isPlaying = false;
            });
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error playing audio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pauseAudio() async {
    try {
      if (_player != null && _isPlaying) {
        await _player!.stopPlayer();
        setState(() {
          _isPlaying = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error pausing audio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImagePreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImages[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                      ),
                      child: const Text('Close', style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _selectedImages.clear();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Remove All', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addCurrentLocation() {
    setState(() {
      _locationController.text = "123 Main St, Springfield"; // placeholder
    });
  }

  // ---------------------------------------------------------------------------
  // SUBMIT: updated to upload media to Cloudinary, then save report to Firestore
  // ---------------------------------------------------------------------------
  Future<void> _submitReport() async {
    // prevent double submissions
    if (_isSubmitting) return;

    // basic validation (you can expand this)
    if (_descriptionController.text.trim().isEmpty || _locationController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please provide description and location')),
        );
      }
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Uploading report...')),
        );
      }

      final cloud = CloudinaryService();
      final List<String> uploadedImageUrls = [];

      // Upload each selected image
      for (final img in _selectedImages) {
        try {
          final url = await cloud.uploadImage(img);
          if (url != null) {
            uploadedImageUrls.add(url);
          } else {
            // Non-fatal: record failed upload, continue
            print('Warning: image upload returned null for ${img.path}');
          }
        } catch (e) {
          print('Image upload error for ${img.path}: $e');
        }
      }

      // Upload audio if present
      String? audioUrl;
      if (_audioPath != null) {
        try {
          final audioFile = File(_audioPath!);
          final aUrl = await cloud.uploadAudio(audioFile);
          if (aUrl != null) {
            audioUrl = aUrl;
          } else {
            print('Warning: audio upload returned null for $_audioPath');
          }
        } catch (e) {
          print('Audio upload error: $e');
        }
      }

      // Save report data to Firestore
      await ReportService().addReport(
        description: _descriptionController.text.trim(),
        locationText: _locationController.text.trim(),
        tags: _selectedTags.toList(),
        imageUrls: uploadedImageUrls,
        audioUrl: audioUrl,
      );

      // success feedback + reset form (keeps UI look identical to original)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted successfully!')),
        );
      }

      _locationController.clear();
      _descriptionController.clear();
      _selectedTags.clear();
      setState(() {
        _selectedImages.clear();
        _audioPath = null;
        _isRecording = false;
        _isPlaying = false;
      });
      if (_isPlaying) {
        _player?.stopPlayer();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit report: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
