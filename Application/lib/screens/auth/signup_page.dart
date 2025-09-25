import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import 'verify_email_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = "Citizen";
  bool _obscurePassword = true;

  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;

  final AuthService _authService = AuthService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 700));
    _scaleAnim = Tween(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutBack));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _rolePill(String role) {
    final bool selected = _selectedRole == role;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedRole = role),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: selected
                ? LinearGradient(colors: [Color(0xFF6D28D9), Color(0xFF3B82F6)])
                : null,
            color: selected ? null : Colors.white.withOpacity(0.03),
            border: Border.all(
                color: selected ? Colors.transparent : Colors.white.withOpacity(0.03)),
            boxShadow: selected
                ? [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 8, offset: Offset(0, 4))]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selected) Icon(Icons.check, size: 16, color: Colors.white),
              if (selected) SizedBox(width: 6),
              Text(role,
                  style: TextStyle(
                      color: selected ? Colors.white : Colors.white70,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleCreateAccount() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    setState(() => _loading = true);
    try {
      // Attempt sign up (this normally also signs in the user)
      final user = await _authService.signUp(email, password, _selectedRole);

      // Defensive: ensure currentUser is available and fresh
      final auth = FirebaseAuth.instance;
      User? current = auth.currentUser;

      if (current == null) {
        // Some platforms/conditions might not have currentUser immediately.
        // Fallback: try signing in immediately with same credentials.
        try {
          final signInResult = await auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          current = signInResult.user;
        } catch (e) {
          // If sign-in fails, let user know they should sign in manually.
          setState(() => _loading = false);
          _showSnack('Please sign in to continue (auto sign-in failed).');
          return;
        }
      }

      // Reload to make sure emailVerified status is current
      await current!.reload();

      setState(() => _loading = false);

      if (user != null) {
        // Navigate to verification (currentUser is present & reloaded)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => VerifyEmailPage(email: email)),
        );
      } else {
        _showSnack('Signup failed. Try again.');
      }
    } catch (e) {
      setState(() => _loading = false);
      _showSnack(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF312E81)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Material(
                        elevation: 6,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.location_city, size: 32, color: Color(0xFF312E81)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                          SizedBox(height: 4),
                          Text('Join CivicSync to report issues', style: TextStyle(fontSize: 12, color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 28),

                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 12,
                  color: Colors.white.withOpacity(0.04),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _rolePill('Citizen'),
                              SizedBox(width: 10),
                              _rolePill('Staff'),
                            ],
                          ),

                          SizedBox(height: 18),

                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white70),
                              hintText: 'you@example.com',
                              hintStyle: TextStyle(color: Colors.white38),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.02),
                              prefixIcon: Icon(Icons.email, color: Colors.white70),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter your email';
                              if (!value.contains('@')) return 'Enter a valid email';
                              return null;
                            },
                          ),

                          SizedBox(height: 14),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.02),
                              prefixIcon: Icon(Icons.lock, color: Colors.white70),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter your password';
                              if (value.length < 6) return 'Password must be at least 6 characters';
                              return null;
                            },
                          ),

                          SizedBox(height: 18),

                          SizedBox(
                            width: double.infinity,
                            child: Material(
                              borderRadius: BorderRadius.circular(12),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Color(0xFF6D28D9), Color(0xFF3B82F6)]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: _loading ? null : _handleCreateAccount,
                                  child: Container(
                                    height: 48,
                                    alignment: Alignment.center,
                                    child: _loading
                                        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.2))
                                        : Text('Create account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account?', style: TextStyle(color: Colors.white70)),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Sign in', style: TextStyle(fontWeight: FontWeight.w600)),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
