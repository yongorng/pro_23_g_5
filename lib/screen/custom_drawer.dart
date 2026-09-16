import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_color.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.surface,
      child: Column(
        children: [
          // ===== HEADER =====
          Container(
            width: double.infinity,
            height: 200,
            color: AppColor.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: AppColor.surface,
                  radius: 40,
                  child: Text(
                    'AD',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'GetX Basic',
                  style: TextStyle(
                    color: AppColor.textOnPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'admin@example.com',
                  style: TextStyle(
                    color: AppColor.textOnPrimary.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // ===== MENU ITEMS =====
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.people_outline, color: AppColor.textPrimary),
                  title: Text('Users'.tr),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.person_add, color: AppColor.textPrimary),
                  title: Text('New_user'.tr),
                  onTap: () => Navigator.pop(context),
                ),
                const Divider(),

                // Language Selector
                ListTile(
                  leading: const Icon(Icons.language, color: AppColor.textPrimary),
                  title: Text('language'.tr),
                  onTap: () {
                    Navigator.pop(context);
                    _showLanguageDialog();
                  },
                ),

                // Connection Status
                ListTile(
                  leading: const Icon(Icons.signal_cellular_alt, color: AppColor.textPrimary),
                  title: Text('Connection'.tr),
                  trailing: Text(
                    'Online'.tr,
                    style: TextStyle(color: AppColor.success, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),

          // ===== LOGOUT =====
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColor.error),
            title: Text('Logout'.tr),
            onTap: _showLogoutDialog,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('select_language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('english'.tr),
              onTap: () {
                Get.updateLocale(const Locale('en', 'US'));
                Get.back();
              },
            ),
            ListTile(
              title: Text('khmer'.tr),
              onTap: () {
                Get.updateLocale(const Locale('km', 'KH'));
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }


  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Logout'.tr),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {

              Get.back();

              Get.offAllNamed('/login');

              Get.snackbar('Success', 'Logged out successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColor.success,
                  colorText: AppColor.textOnPrimary);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.error),
            child: Text('Logout'.tr),
          ),
        ],
      ),
    );
  }
}