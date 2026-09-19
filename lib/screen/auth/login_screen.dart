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
    setState(() {
      _isLoading = true;
    });

    final api = Get.find<ApiClient>();
    final storage = Get.find<TokenStorage>();

    try {
      final response = await api.post('/auth/login', body: {
        'username': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      });

      if (response.containsKey('token')) {
        await storage.save(response['token']);
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
          'Invalid credentials',
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface, // ✅ ប្រើពណ៌ផ្ទៃរបស់ App
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ✅ ប្រើ AppColor សម្រាប់ Title
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary, // ✅ ពណ៌ដើមរបស់ App
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

                // ✅ Email Field
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: AppColor.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Email / Username',
                    labelStyle: TextStyle(color: AppColor.textSecondary),
                    hintText: 'Enter your username',
                    hintStyle: TextStyle(color: AppColor.textSecondary.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.person_outline, color: AppColor.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColor.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColor.primary.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColor.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // ✅ Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: AppColor.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: AppColor.textSecondary),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: AppColor.textSecondary.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.lock_outline, color: AppColor.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColor.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColor.primary.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColor.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),

                // ✅ Login Button - ប្ើ AppColor.primary
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColor.primary,
                    disabledBackgroundColor: AppColor.primary.withOpacity(0.5),
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