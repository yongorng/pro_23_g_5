import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screen/auth/login_screen.dart';
import 'screen/auth/register_screen.dart';
import 'screen/main_screen.dart';
import 'i10n/app_translation.dart';
import 'theme/app_theme.dart';
import 'services/api_client.dart';
import 'utils/token_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tokenStorage = await TokenStorage().init();

  Get.put<TokenStorage>(
    tokenStorage,
    permanent: true,
  );

  Get.put<ApiClient>(
    ApiClient(tokenStorage),
    permanent: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pro 23 G5',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      translations: AppTranslation(),
      locale: const Locale('km', 'KH'),
      fallbackLocale: const Locale('en', 'US'),
      home: const LoginScreen(),
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterScreen(),
        ),
        GetPage(
          name: '/main',
          page: () => const MainScreen(),
        ),
      ],
    );
  }
}
