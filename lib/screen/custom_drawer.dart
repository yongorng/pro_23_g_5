import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // ===== HEADER =====
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.teal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  child: Text(
                    'AD',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'GetX Basic',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'admin@example.com',
                  style: TextStyle(
                    color: Colors.white70,
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
                  leading: Icon(Icons.people_outline),
                  title: Text('Users'.tr),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text('New user'.tr),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(),


                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text('language'.tr),
                  onTap: () {
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
                  },
                ),
                // ==========================================

                ListTile(
                  leading: Icon(Icons.signal_cellular_alt),
                  title: Text('Connection'.tr),
                  trailing: Text(
                    'Online'.tr,
                    style: TextStyle(color: Colors.teal),
                  ),
                  onTap: () {
                    // Connection settings
                  },
                ),
              ],
            ),
          ),

          // ===== LOGOUT =====
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout'.tr, style: TextStyle(color: Colors.red)),
            onTap: () {
              // Logout functionality
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}