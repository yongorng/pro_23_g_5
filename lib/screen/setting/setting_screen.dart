import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_color.dart';
import '../../route/app_route.dart';
import '../../utils/token_storage.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  void _showLanguageDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('select_language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('ភាសាខ្មែរ'),
              trailing: (Get.locale?.languageCode == 'km')
                  ? const Icon(Icons.check, color: AppColor.primary)
                  : null,
              onTap: () {
                Get.updateLocale(const Locale('km', 'KH'));
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('English'),
              trailing: (Get.locale?.languageCode == 'en')
                  ? const Icon(Icons.check, color: AppColor.primary)
                  : null,
              onTap: () {
                Get.updateLocale(const Locale('en', 'US'));
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: 'Admin');
    final emailController = TextEditingController(text: 'admin@example.com');

    Get.dialog(
      AlertDialog(
        title: const Text('កែសម្រួលព័ត៌មាន'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'ឈ្មោះ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'អ៊ីមែល',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('បោះបង់'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Success', 'Information updated',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColor.success,
                  colorText: Colors.white);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
            child: const Text('រក្សាទុក'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('ចាកចេញ'),
        content: const Text('តើអ្នកប្រាកដជាចង់ចាកចេញមែនទេ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('បោះបង់'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.find<TokenStorage>().clear();
              Get.offAllNamed(AppRoute.login);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.error),
            child: const Text('ចាកចេញ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'ការកំណត់'.tr,
          style: const TextStyle(color: AppColor.textPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColor.surface,
                    child: const Text(
                      'AD',
                      style: TextStyle(
                        color: AppColor.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin',
                          style: TextStyle(
                            color: AppColor.textOnPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'admin@example.com',
                          style: TextStyle(
                            color: AppColor.textOnPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Account Section
            _buildSectionTitle('គណនីរបស់អ្នក'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: const Icon(Icons.edit, color: AppColor.primary),
                title: const Text('កែសម្រួលព័ត៌មាន'),
                subtitle: const Text('មើលផ្លាស់ប្ដូរឈ្មោះ និងរូបភាព'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showEditProfileDialog(context),
              ),
            ),

            const SizedBox(height: 16),

            // General Section
            _buildSectionTitle('ទូទៅ'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: const Icon(Icons.language, color: AppColor.primary),
                title: const Text('ភាសា'),
                subtitle: const Text('ប្តូរភាសាកម្មវិធី'),
                trailing: Text(
                  Get.locale?.languageCode == 'km' ? 'ខ្មែរ' : 'English',
                  style: const TextStyle(color: AppColor.primary, fontWeight: FontWeight.w600),
                ),
                onTap: () => _showLanguageDialog(context),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: const Icon(Icons.wifi, color: AppColor.primary),
                title: const Text('ការតភ្ចាប់'),
                trailing: const Text(
                  'Online',
                  style: TextStyle(color: AppColor.success, fontWeight: FontWeight.w600),
                ),
                onTap: () {},
              ),
            ),

            const SizedBox(height: 32),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.error,
                    foregroundColor: AppColor.textOnPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'ចាកចេញ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColor.textSecondary,
        ),
      ),
    );
  }
}