import 'package:flutter/material.dart';
import 'app_color.dart';
import 'app_text_style.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.primary,
        primary: AppColor.primary,
        secondary: AppColor.secondary,
        surface: AppColor.surface,
      ),
      scaffoldBackgroundColor: AppColor.background,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.textOnPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.heading,
      ),


      cardTheme: CardThemeData(
        color: AppColor.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // ElevatedButton Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.textOnPrimary,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColor.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColor.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColor.primary.withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColor.primary,
              width: 2,
            ),
          ),
        ),
    );
  }
}