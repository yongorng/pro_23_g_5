import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/main_controller.dart';
import 'home/home_screen.dart';
import 'post/post_screen.dart';
import 'user/user_screen.dart';
import 'setting/setting_screen.dart';
import 'custom_drawer.dart';
import '../theme/app_color.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ ទុកតែ MainController ប៉ុណ្ណោះ (ព្រោះវាគ្រប់គ្រង Tab)
    final MainController controller = Get.put(MainController());

    return Scaffold(
      drawer: const CustomDrawer(),
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: const [
          HomeScreen(),
          PostScreen(),    // PostScreen នឹងហៅ fetchPosts() ខ្លួនឯងនៅពេលវាត្រូវបាន Build
          UserScreen(),    // UserScreen នឹងហៅ fetchUsers() ខ្លួនឯង
          SettingScreen(),
        ],
      )),
      bottomNavigationBar: Obx(() => NavigationBar(
        selectedIndex: controller.currentIndex.value,
        backgroundColor: AppColor.surface,
        indicatorColor: AppColor.primary.withValues(alpha: 0.2),
        onDestinationSelected: controller.changeTab,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home, color: AppColor.primary),
            label: 'Home'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.article_outlined),
            selectedIcon: const Icon(Icons.article, color: AppColor.primary),
            label: 'Post'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_2_outlined),
            selectedIcon: const Icon(Icons.person, color: AppColor.primary),
            label: 'User'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings, color: AppColor.primary),
            label: 'Setting'.tr,
          ),
        ],
      )),
    );
  }
}