import 'dart:math' as math;
// import 'package:ansvel/controllers/auth_controller.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/auth_controller.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/nin_input_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/password_strength_indicator.dart';
import 'package:ansvel/homeandregistratiodesign/widgets/validation_requirement_widget.dart';
// import 'package:ansvel/views/onboarding/3_nin_input_screen.dart';
// import 'package:ansvel/widgets/password_strength_indicator.dart';
// import 'package:ansvel/widgets/validation_requirement_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

enum AuthScreen { login, signup }

// Removed local PasswordStrength enum; use the one from password_strength_indicator.dart

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _formAnimation;
  var _currentScreen = AuthScreen.signup;

  // Separate controllers for each form to maintain their state
  final _signupUsernameController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupConfirmPasswordController = TextEditingController();
  final _loginUsernameController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  // State for Signup Form Validation
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isUsernameLengthValid = false;
  bool _usernameHasNoSpaces = false;
  bool _isUsernameCharsValid = false;
  PasswordStrength _passwordStrength = PasswordStrength.Empty;
  bool _passwordsMatch = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _formAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Add listeners for real-time validation on the signup form
    _signupUsernameController.addListener(_validateUsername);
    _signupPasswordController.addListener(_validatePassword);
    _signupConfirmPasswordController.addListener(_validatePassword);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _signupUsernameController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();
    _loginUsernameController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  // --- VALIDATION LOGIC FOR SIGN UP FORM ---
  void _validateUsername() {
    final username = _signupUsernameController.text;
    final emailString = "$username@ansveluseremail.com";
    final validCharsRegex = RegExp(r"^[a-zA-Z0-9._-]+$");
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    setState(() {
      _isUsernameLengthValid = username.length >= 6;
      _usernameHasNoSpaces = !username.contains(' ');
      _isUsernameCharsValid =
          validCharsRegex.hasMatch(username) &&
          emailRegex.hasMatch(emailString);
    });
  }

  void _validatePassword() {
    final password = _signupPasswordController.text;
    setState(() {
      _passwordsMatch =
          password.isNotEmpty &&
          password == _signupConfirmPasswordController.text;
      if (password.isEmpty) {
        _passwordStrength = PasswordStrength.Empty;
        return;
      }
      int score = 0;
      if (password.length >= 8) score++;
      if (RegExp(r'[A-Z]').hasMatch(password)) score++;
      if (RegExp(r'[a-z]').hasMatch(password)) score++;
      if (RegExp(r'[0-9]').hasMatch(password)) score++;
      if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;

      if (score < 2 || password.length < 8)
        _passwordStrength = PasswordStrength.Weak;
      else if (score == 2)
        _passwordStrength = PasswordStrength.Normal;
      else if (score == 3)
        _passwordStrength = PasswordStrength.Strong;
      else if (score >= 4)
        _passwordStrength = PasswordStrength.VeryStrong;
    });
  }

  bool get _isSignupFormValid =>
      _isUsernameLengthValid &&
      _usernameHasNoSpaces &&
      _isUsernameCharsValid &&
      _passwordsMatch &&
      _passwordStrength != PasswordStrength.Weak;

  void _switchScreen() {
    setState(() {
      _currentScreen == AuthScreen.signup
          ? _animationController.reverse().then(
              (_) => setState(() => _currentScreen = AuthScreen.login),
            )
          : _animationController.forward().then(
              (_) => setState(() => _currentScreen = AuthScreen.signup),
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Colors.deepPurple.shade300;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -160,
            left: -30,
            child: _TopWidget(
              screenWidth: screenSize.width,
              color: primaryColor,
            ),
          ),
          Positioned(
            bottom: -180,
            left: -40,
            child: _BottomWidget(
              screenWidth: screenSize.width,
              color: secondaryColor,
            ),
          ),
          AnimatedBuilder(
            animation: _formAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  Transform.translate(
                    offset: Offset(
                      -screenSize.width * (1 - _formAnimation.value),
                      0,
                    ),
                    child: Opacity(
                      opacity: _formAnimation.value,
                      child: _buildSignupForm(context),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(screenSize.width * _formAnimation.value, 0),
                    child: Opacity(
                      opacity: 1 - _formAnimation.value,
                      child: _buildLoginForm(context),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm(BuildContext context) {
    final auth = Provider.of<AuthController>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Create\nAccount",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          _InputField(
            controller: _signupUsernameController,
            hint: "Username or Phone Number",
            iconData: FontAwesomeIcons.user,
          ),
          const SizedBox(height: 8),
          ValidationRequirementWidget(
            text: "At least 6 characters long",
            isValid: _isUsernameLengthValid,
          ),
          ValidationRequirementWidget(
            text: "No spaces allowed",
            isValid: _usernameHasNoSpaces,
          ),
          ValidationRequirementWidget(
            text: "Only letters, numbers, '.', '_', '-' are allowed",
            isValid: _isUsernameCharsValid,
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _signupPasswordController,
            hint: "Password",
            iconData: FontAwesomeIcons.lock,
            isPassword: true,
            isVisible: _isPasswordVisible,
            onVisibilityToggle: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
          const SizedBox(height: 8),
          PasswordStrengthIndicator(strength: _passwordStrength),
          const SizedBox(height: 16),
          _InputField(
            controller: _signupConfirmPasswordController,
            hint: "Confirm Password",
            iconData: FontAwesomeIcons.lock,
            isPassword: true,
            isVisible: _isConfirmPasswordVisible,
            onVisibilityToggle: () => setState(
              () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
            ),
            errorText:
                (_signupConfirmPasswordController.text.isNotEmpty &&
                    !_passwordsMatch)
                ? "Passwords do not match"
                : null,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isLoading || !_isSignupFormValid
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    final email =
                        "${_signupUsernameController.text.trim()}@ansveluseremail.com";
                    final password = _signupPasswordController.text;
                    final username = _signupUsernameController.text.trim();

                    final error = await auth.createAccount(
                      email: email,
                      password: password,
                      username: username,
                    );
                    if (!mounted) return;
                    setState(() {
                      _isLoading = false;
                    });

                    if (error == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NinInputScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("SIGN UP"),
          ),
          const SizedBox(height: 24),
          _BottomText(onTap: _switchScreen, isLogin: false),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final auth = Provider.of<AuthController>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Welcome\nBack",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          _InputField(
            controller: _loginUsernameController,
            hint: "Username or Phone Number",
            iconData: FontAwesomeIcons.user,
          ),
          _InputField(
            controller: _loginPasswordController,
            hint: "Password",
            iconData: FontAwesomeIcons.lock,
            isPassword: true,
            isVisible: _isPasswordVisible,
            onVisibilityToggle: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    final email =
                        "${_loginUsernameController.text.trim()}@ansveluseremail.com";
                    final password = _loginPasswordController.text;
                    final error = await auth.signIn(
                      email: email,
                      password: password,
                    );
                    if (!mounted) return;
                    setState(() {
                      _isLoading = false;
                    });

                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("LOG IN"),
          ),
          const SizedBox(height: 32),
          _BottomText(onTap: _switchScreen, isLogin: true),
        ],
      ),
    );
  }
}

// --- Helper Widgets for this screen ---

class _InputField extends StatelessWidget {
  final String hint;
  final IconData iconData;
  final bool isPassword;
  final TextEditingController? controller;
  final bool isVisible;
  final VoidCallback? onVisibilityToggle;
  final String? errorText;

  const _InputField({
    required this.hint,
    required this.iconData,
    this.isPassword = false,
    this.controller,
    this.isVisible = false,
    this.onVisibilityToggle,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        child: TextField(
          controller: controller,
          obscureText: isPassword && !isVisible,
          decoration: InputDecoration(
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            prefixIcon: Icon(
              iconData,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: onVisibilityToggle,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _BottomText extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLogin;
  const _BottomText({required this.onTap, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
            children: [
              TextSpan(
                text: isLogin
                    ? 'Don\'t have an account? '
                    : 'Already have an account? ',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: isLogin ? 'Sign Up' : 'Log In',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopWidget extends StatelessWidget {
  final double screenWidth;
  final Color color;
  const _TopWidget({required this.screenWidth, required this.color});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -35 * math.pi / 180,
      child: Container(
        width: 1.2 * screenWidth,
        height: 1.2 * screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          gradient: LinearGradient(
            begin: const Alignment(-0.2, -0.8),
            end: Alignment.bottomCenter,
            colors: [color.withOpacity(0.2), color.withOpacity(0.8)],
          ),
        ),
      ),
    );
  }
}

class _BottomWidget extends StatelessWidget {
  final double screenWidth;
  final Color color;
  const _BottomWidget({required this.screenWidth, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.5 * screenWidth,
      height: 1.5 * screenWidth,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: const Alignment(0.6, -1.1),
          end: const Alignment(0.7, 0.8),
          colors: [color.withOpacity(0.8), color.withOpacity(0.0)],
        ),
      ),
    );
  }
}
