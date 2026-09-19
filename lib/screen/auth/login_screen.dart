import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/api_client.dart';
import '../../utils/token_storage.dart';
import '../../theme/app_color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your username and password',
        backgroundColor: AppColor.error,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final api = Get.find<ApiClient>();
    final storage = Get.find<TokenStorage>();

    try {
      final response = await api.post('/auth/login', body: {
        'username': _emailController.text.trim(),
        'password': _passwordController.text,
      });

      final dynamic data = response['data'] is Map
          ? response['data']
          : response;

      final dynamic rawToken = data['token'] ??
          data['access_token'] ??
          data['accessToken'];

      final String? token = rawToken is String
          ? rawToken.trim()
          : rawToken?.toString();

      if (token != null && token.isNotEmpty) {
        await storage.save(token);

        if (!storage.hasToken) {
          throw Exception('Unable to save authentication token');
        }

        Get.snackbar(
          'Success',
          'Login successful!',
          backgroundColor: AppColor.primary,
          colorText: AppColor.textOnPrimary,
        );
        Get.offAllNamed('/main');
      } else {
        Get.snackbar(
          'Error',
          'Login succeeded but no authentication token was returned',
          backgroundColor: AppColor.error,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColor.error,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColor.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: AppColor.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Email / Username',
                    labelStyle: TextStyle(color: AppColor.textSecondary),
                    hintText: 'Enter your username',
                    hintStyle: TextStyle(
                      color: AppColor.textSecondary.withOpacity(0.5),
                    ),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppColor.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColor.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColor.primary.withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColor.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: AppColor.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: AppColor.textSecondary),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(
                      color: AppColor.textSecondary.withOpacity(0.5),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColor.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColor.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColor.primary.withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColor.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColor.primary,
                    disabledBackgroundColor:
                        AppColor.primary.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColor.textOnPrimary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Pro 23 App',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.textSecondary.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}