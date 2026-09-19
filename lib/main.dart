import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import Screens
import 'screen/auth/login_screen.dart';
import 'screen/main_screen.dart';

// Import Controller & Theme
import 'i10n/app_translation.dart';
import 'theme/app_theme.dart';

// Import Services
import 'services/api_client.dart';
import 'utils/token_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ១. អាន Token ពី Storage
  final tokenStorage = await TokenStorage().init();
  Get.put<TokenStorage>(tokenStorage, permanent: true);

  // ២. បង្កើត ApiClient
  Get.put<ApiClient>(ApiClient(tokenStorage), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pro 23 G5', // ✅ ប្តូរឈ្មោះ App តាមដែលអ្នកចង់បាន
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      translations: AppTranslation(),
      locale: const Locale('km', 'KH'),
      fallbackLocale: const Locale('en', 'US'),

      // ✅ លុប ឬ Comment initialBinding នេះចោល!
      // កុំឱ្យវាបង្កើត PostController មុនពេល Login
      // initialBinding: BindingsBuilder(() {
      //   Get.put(PostController());
      // }),

      home: const LoginScreen(),
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/main', page: () => const MainScreen()),
      ],
    );
  }
}