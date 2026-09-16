import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColor.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColor.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    color: AppColor.textSecondary,
    height: 1.5, // Improves readability
  );

  static const TextStyle caption = TextStyle(
    fontSize: 13,
    color: AppColor.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColor.textOnPrimary,
    letterSpacing: 0.5,
  );
}