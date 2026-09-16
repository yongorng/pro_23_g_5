import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_color.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RxBool _isPasswordVisible = false.obs;
  final RxBool _isLoading = false.obs;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.error,
          colorText: AppColor.textOnPrimary);
      return;
    }

    _isLoading.value = true;

    try {
      // TODO: ដាក់ Logic Login របស់អ្នកនៅទីនេះ
      await Future.delayed(const Duration(seconds: 1)); // Mock delay


      Get.offAllNamed('/main');

      Get.snackbar('Success', 'Login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.success,
          colorText: AppColor.textOnPrimary);
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.error,
          colorText: AppColor.textOnPrimary);
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),


              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColor.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    size: 40,
                    color: AppColor.primary,
                  ),
                ),
              ),

              const SizedBox(height: 24),


              Center(
                child: Text(
                  'សូមស្វាគមន៍មកកាន់កម្មវិធី',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  'ចូលទៅកាន់គណនីរបស់អ្នក',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              Text(
                'អ៊ីមែល',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'admin@example.com',
                  prefixIcon: Icon(Icons.email_outlined, color: AppColor.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColor.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),

              const SizedBox(height: 20),


              Text(
                'ពាក្យសម្ងាត់',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible.value,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: Icon(Icons.lock_outline, color: AppColor.primary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                      color: AppColor.textSecondary,
                    ),
                    onPressed: () {
                      _isPasswordVisible.value = !_isPasswordVisible.value;
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColor.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              )),

              const SizedBox(height: 32),


              Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading.value ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.textOnPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading.value
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ចូលទៅកាន់គណនី',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              )),

              const SizedBox(height: 24),


              Center(
                child: TextButton(
                  onPressed: () {
                    Get.to(() => const RegisterScreen());
                  },
                  child: Text(
                    'មិនទាន់មានគណនី? ចុះឈ្មោះ',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}