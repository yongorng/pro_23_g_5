import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/main_controller.dart';
import '../controller/post_controller.dart';
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
    final mainController = Get.put(MainController());

    if (!Get.isRegistered<PostController>()) {
      Get.put(PostController());
    }

    return Scaffold(
      drawer: const CustomDrawer(),
      body: Obx(
        () => IndexedStack(
          index: mainController.currentIndex.value,
          children: const [
            HomeScreen(),
            PostScreen(),
            UserScreen(),
            SettingScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: mainController.currentIndex.value,
          backgroundColor: AppColor.surface,
          indicatorColor: AppColor.primary.withValues(alpha: 0.2),
          onDestinationSelected: mainController.changeTab,
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
        ),
      ),
    );
  }
}
