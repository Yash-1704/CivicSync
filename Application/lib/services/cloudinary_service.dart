// lib/services/cloudinary_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Simple Cloudinary helper for unsigned uploads.
/// Make sure you set an **Unsigned** upload preset in Cloudinary
/// and replace CLOUD_NAME and UPLOAD_PRESET below.
class CloudinaryService {
  // TODO: replace these with your Cloudinary values
  final String cloudName = 'dyausrnbc';
  final String uploadPreset = 'CivicSync_Preset';

  /// Upload any file (image/audio/video). Returns the secure_url on success, null on failure.
  Future<String?> uploadFile(File file) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/auto/upload');

    try {
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> map = json.decode(response.body);
        return map['secure_url'] as String?;
      } else {
        // Debug: print body to help troubleshooting
        print('Cloudinary upload failed (${response.statusCode}): ${response.body}');
        return null;
      }
    } catch (e) {
      print('Cloudinary upload exception: $e');
      return null;
    }
  }

  /// Convenience aliases (optional)
  Future<String?> uploadImage(File file) => uploadFile(file);
  Future<String?> uploadAudio(File file) => uploadFile(file);
}
