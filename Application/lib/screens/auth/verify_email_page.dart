import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/home_user.dart';
import 'login_page.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;
  const VerifyEmailPage({super.key, required this.email});

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _busy = false;
  Timer? _pollTimer;
  int _resendCooldown = 0;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(Duration(seconds: 3), (_) => _checkVerified());
  }

  Future<void> _checkVerified() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        // If there's no current user, prompt to sign in again
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No active session. Please sign in again.')),
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false);
        return;
      }

      await user.reload();
      final fresh = _auth.currentUser;
      if (fresh?.emailVerified ?? false) {
        _pollTimer?.cancel();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeUser()),
        );
      } else {
        // still not verified; do nothing (poll will continue)
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking verification: ${e.toString()}')),
      );
    }
  }

  Future<void> _resendVerification() async {
    if (_resendCooldown > 0) return;
    setState(() => _busy = true);
    try {
      final user = _auth.currentUser;
      if (user == null) {
        // No user: ask to sign in on login page to restore session
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No active session. Please sign in again to resend verification.')),
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false);
        return;
      }

      if (!user.emailVerified) {
        await user.sendEmailVerification();
        _startCooldown();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification email sent to ${widget.email}')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email already verified.')),
        );
        // navigate to home if verified already
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeUser()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send verification: ${e.toString()}')),
      );
    } finally {
      if (!mounted) return;
      setState(() => _busy = false);
    }
  }

  void _startCooldown() {
    setState(() => _resendCooldown = 30);
    Timer.periodic(Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_resendCooldown > 0) _resendCooldown--;
        else t.cancel();
      });
    });
  }

  Future<void> _logout() async {
    await _auth.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        alignment: Alignment.center,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email, size: 60),
                SizedBox(height: 12),
                Text('Verify your email', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                SizedBox(height: 8),
                Text(
                  'A verification link was sent to ${widget.email}. Open your email and click the link to activate your account.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _busy ? null : _resendVerification,
                  child: _busy
                      ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(_resendCooldown > 0 ? 'Resend (${_resendCooldown}s)' : 'Resend verification'),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: _checkVerified,
                  child: Text('I have verified (check now)'),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: _logout,
                  child: Text('Cancel / Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
