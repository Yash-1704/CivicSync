// lib/services/report_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// ReportService writes a report document to Firestore.
/// Expects that authentication is handled (FirebaseAuth.currentUser is not null).
class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Creates a new report in `reports` collection.
  /// - [description] : main text
  /// - [locationText] : human-readable address or description
  /// - [tags] : list of selected tags/strings
  /// - [imageUrls] : list of URLs (Cloudinary or other)
  /// - [audioUrl] : optional audio URL
  Future<DocumentReference> addReport({
    required String description,
    required String locationText,
    required List<String> tags,
    required List<String> imageUrls,
    String? audioUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Not authenticated. Please sign in.');
    }

    final docData = <String, dynamic>{
      'userId': user.uid,
      'description': description,
      'location': locationText,
      'tags': tags,
      'imageUrls': imageUrls,
      'audioUrl': audioUrl,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    return await _firestore.collection('reports').add(docData);
  }
}
