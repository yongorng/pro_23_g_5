import 'package:flutter/material.dart';
import 'package:pro_23/screen/home/home_screen.dart';
import 'package:pro_23/screen/post/post_screen.dart';
import 'package:pro_23/screen/setting/setting_screen.dart';
import 'package:pro_23/screen/user/user_screen.dart';
import 'package:pro_23/screen/custom_drawer.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: IndexedStack(
        index: currentIndex,
        children: [HomeScreen(), PostScreen(), UserScreen(), SettingScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        indicatorColor: Colors.green,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home'.tr,
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: 'Post'.tr,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'User'.tr,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Setting'.tr,
          ),
        ],
      ),
    );
  }
}
