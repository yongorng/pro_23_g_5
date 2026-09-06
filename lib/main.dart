import 'package:flutter/material.dart';
import 'package:pro_23/screen/main_screen.dart';
import 'package:get/get.dart';
import 'i10n/app_translation.dart';
import 'controller/post_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pro 23 App',
      debugShowCheckedModeBanner: false,

      translations: AppTranslation(),
      locale: const Locale('km', 'US'),
      fallbackLocale: const Locale('en', 'US'),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(PostController());
      }),

      home: const MainScreen(),
    );
  }
}