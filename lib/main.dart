import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'binding/dependency_injection_binding.dart';
import 'route/app_page.dart';
import 'route/app_route.dart';
import 'i10n/app_translation.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DependencyInjectionBinding.init();

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
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('km', 'KH'),
        Locale('en', 'US'),
      ],
      initialRoute: AppRoute.login,
      getPages: AppPage.pages,
      defaultTransition: Transition.cupertino,
    );
  }
}
