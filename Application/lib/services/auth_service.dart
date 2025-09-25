import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with Email & Password. Sets displayName to role, sends verification, and writes role to Firestore.
  Future<User?> signUp(String email, String password, String role) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Set display name (optional)
        await user.updateDisplayName(role);
        await user.reload();
        user = _auth.currentUser;

        // Send email verification
        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
        }

        // Store user profile in Firestore (optional, recommended)
        try {
          await _firestore.collection('users').doc(user!.uid).set({
            'email': user.email,
            'role': role,
            'displayName': user.displayName ?? role,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        } catch (e) {
          // Non-fatal: Firestore write failed (log it)
          print('Firestore write failed: $e');
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? e.code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Sign in with Email & Password.
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? e.code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Current user
  User? get currentUser => _auth.currentUser;
}
