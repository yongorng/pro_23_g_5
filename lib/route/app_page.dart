import 'package:get/get.dart';

import '../screen/auth/login_screen.dart';
import '../screen/auth/register_screen.dart';
import '../screen/main_screen.dart';
import 'app_route.dart';
import '../binding/main_binding.dart';

class AppPage {
  const AppPage._();

  static final List<GetPage<dynamic>> pages = [
    GetPage<dynamic>(
      name: AppRoute.login,
      page: () => const LoginScreen(),
    ),
    GetPage<dynamic>(
      name: AppRoute.register,
      page: () => const RegisterScreen(),
    ),
    GetPage<dynamic>(
      name: AppRoute.main,
      page: () => const MainScreen(),
      binding: MainBinding(),
    ),
  ];
}
