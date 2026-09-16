import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_color.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RxBool _isPasswordVisible = false.obs;
  final RxBool _isLoading = false.obs;

  Future<void> _register() async {
    if (_emailController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.error,
          colorText: AppColor.textOnPrimary);
      return;
    }

    if (_passwordController.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.error,
          colorText: AppColor.textOnPrimary);
      return;
    }

    _isLoading.value = true;

    try {
      // TODO: ដាក់ Logic Register របស់អ្នកនៅទីនេះ
      await Future.delayed(const Duration(seconds: 1));

      Get.back();
      Get.snackbar('Success', 'Registration successful! Please login.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.success,
          colorText: AppColor.textOnPrimary);
    } catch (e) {
      Get.snackbar('Error', 'Registration failed: $e',
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'បង្កើតគណនីថ្មី',
          style: TextStyle(color: AppColor.textPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),


              Text(
                'អ៊ីមែលប្រើប្រាស់ (អ៊ីមែល)',
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
                  hintText: 'student@example.com',

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
                'ឈ្មោះហៅក្រៅ (និស្សិតជាប់)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'ប្រសិនបើចាំបាច់ ដាក់ឈ្មោះនិងបង្ហាញខលួន',

                  prefixIcon: Icon(Icons.person_outline, color: AppColor.primary),
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
                  hintText: 'Student@123',

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

              const SizedBox(height: 12),

              Text(
                'យ៉ាងហោចណាស់ ៤ តួអក្សរ ដោយមានអក្សរធំ អក្សរតូច លេខ និងសញ្ញាពិសេស។',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.textSecondary,
                ),
              ),

              const SizedBox(height: 32),


              Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading.value ? null : _register,
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
                      Icon(Icons.person_add, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'ចុះឈ្មោះ',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}