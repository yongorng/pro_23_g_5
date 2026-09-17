import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import Screens
import 'screen/auth/login_screen.dart';
import 'screen/main_screen.dart';

// Import Controller & Theme
import 'controller/post_controller.dart';
import 'i10n/app_translation.dart';
import 'theme/app_theme.dart';


import 'services/api_service.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();


  await ApiService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pro 23 App',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      // Translations
      translations: AppTranslation(),
      locale: const Locale('km', 'KH'),
      fallbackLocale: const Locale('en', 'US'),

      // Initial Binding
      initialBinding: BindingsBuilder(() {
        Get.put(PostController());
      }),

      home: const LoginScreen(),
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/main', page: () => const MainScreen()),
      ],
    );
  }
}