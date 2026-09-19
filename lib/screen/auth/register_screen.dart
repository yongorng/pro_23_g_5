import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/api_client.dart';
import '../../theme/app_color.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }

    if (username.length < 3) {
      _showError('Username must be at least 3 characters.');
      return;
    }

    if (password.length < 6) {
      _showError('Password must be at least 6 characters.');
      return;
    }

    if (password != confirmPassword) {
      _showError('Passwords do not match.');
      return;
    }

    setState(() => _loading = true);

    try {
      final api = Get.find<ApiClient>();

      await api.post(
        '/auth/register',
        body: {
          'username': username,
          'password': password,
        },
      );

      if (!mounted) return;

      Get.snackbar(
        'Registration successful',
        'Account created. Please login.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.success,
        colorText: Colors.white,
      );

      Get.offNamed('/login');
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      _showError(message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Registration failed',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.error,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  InputDecoration _decoration(String label, IconData icon, Widget? suffix) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColor.primary),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: AppBar(
        backgroundColor: AppColor.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.textPrimary),
          onPressed: _loading ? null : () => Get.offNamed('/login'),
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(color: AppColor.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Register a new account',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColor.textSecondary),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _usernameController,
                    enabled: !_loading,
                    textInputAction: TextInputAction.next,
                    decoration: _decoration(
                      'Username',
                      Icons.person_outline,
                      null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    enabled: !_loading,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    decoration: _decoration(
                      'Password',
                      Icons.lock_outline,
                      IconButton(
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _confirmPasswordController,
                    enabled: !_loading,
                    obscureText: _obscureConfirmPassword,
                    onSubmitted: (_) => _register(),
                    decoration: _decoration(
                      'Confirm Password',
                      Icons.lock_reset_outlined,
                      IconButton(
                        onPressed: () => setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        ),
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: AppColor.textOnPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _loading ? null : () => Get.offNamed('/login'),
                    child: const Text('Already have an account? Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
