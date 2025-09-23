import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'signup_page.dart';
import '../home/home_user.dart';
import '../../services/theme_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  String _selectedRole = "Citizen";

  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _scaleAnim = Tween(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _rolePill(
    BuildContext context,
    ThemeService themeService,
    String role,
  ) {
    final bool selected = _selectedRole == role;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedRole = role),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: selected ? themeService.getAccentGradient(context) : null,
            color: selected
                ? null
                : (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.03)
                      : Colors.grey.withOpacity(0.1)),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.03)
                        : Colors.grey.withOpacity(0.3)),
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selected) Icon(Icons.check, size: 16, color: Colors.white),
              if (selected) SizedBox(width: 6),
              Text(
                role,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : themeService.getSecondaryTextColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: themeService.getBackgroundGradient(context),
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
                              radius: 40,
                              backgroundColor:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : themeService.getSecondaryBackgroundColor(
                                      context,
                                    ),
                              child: Icon(
                                Icons.location_city,
                                size: 36,
                                color: themeService.getSecondaryBackgroundColor(
                                  context,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CivicSync',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: themeService.getPrimaryTextColor(
                                    context,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Report. Track. Resolve.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: themeService.getSecondaryTextColor(
                                    context,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 36),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.04)
                          : Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  _rolePill(context, themeService, 'Citizen'),
                                  SizedBox(width: 10),
                                  _rolePill(context, themeService, 'Staff'),
                                ],
                              ),

                              SizedBox(height: 18),

                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  color: themeService.getPrimaryTextColor(
                                    context,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    color: themeService.getSecondaryTextColor(
                                      context,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withOpacity(0.02)
                                      : Colors.grey.withOpacity(0.1),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: themeService.getSecondaryTextColor(
                                      context,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 12,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 14),

                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: TextStyle(
                                  color: themeService.getPrimaryTextColor(
                                    context,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: themeService.getSecondaryTextColor(
                                      context,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withOpacity(0.02)
                                      : Colors.grey.withOpacity(0.1),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: themeService.getSecondaryTextColor(
                                      context,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 12,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: themeService.getSecondaryTextColor(
                                        context,
                                      ),
                                    ),
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 12),

                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (val) => setState(
                                      () => _rememberMe = val ?? false,
                                    ),
                                    activeColor: themeService
                                        .getPrimaryAccentColor(context),
                                    checkColor: Colors.white,
                                  ),
                                  Text(
                                    'Remember me',
                                    style: TextStyle(
                                      color: themeService.getSecondaryTextColor(
                                        context,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      'Forgot?',
                                      style: TextStyle(
                                        color: themeService
                                            .getSecondaryTextColor(context),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 12),

                              SizedBox(
                                width: double.infinity,
                                child: Material(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: themeService.getAccentGradient(
                                        context,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {
                                        if (_formKey.currentState!.validate()) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => HomeUser(),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Sign in',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 14),

                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: themeService
                                          .getSecondaryTextColor(context)
                                          .withOpacity(0.24),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      'or continue with',
                                      style: TextStyle(
                                        color: themeService
                                            .getSecondaryTextColor(context),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: themeService
                                          .getSecondaryTextColor(context)
                                          .withOpacity(0.24),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 12),

                              Row(
                                children: [
                                  Expanded(
                                    child: _socialButton(
                                      context: context,
                                      themeService: themeService,
                                      icon: Icons.g_mobiledata,
                                      label: 'Google',
                                      onTap: () {},
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: _socialButton(
                                      context: context,
                                      themeService: themeService,
                                      icon: Icons.g_mobiledata,
                                      label: 'Phone',
                                      onTap: () {},
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 14),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                      color: themeService.getSecondaryTextColor(
                                        context,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SignUpPage(),
                                      ),
                                    ),
                                    child: Text(
                                      'Sign up',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: themeService
                                            .getPrimaryAccentColor(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _socialButton({
    required BuildContext context,
    required ThemeService themeService,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withOpacity(0.03)
          : Colors.grey.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: themeService.getSecondaryTextColor(context)),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: themeService.getSecondaryTextColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
