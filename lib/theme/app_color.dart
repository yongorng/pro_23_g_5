import 'package:flutter/material.dart';

/// The single source of colour for the app.
///
/// Nothing else should write a raw `Color(0xFF...)`; add it here instead, so a
/// palette change is one edit rather than a search across every screen.
class AppColor {
  const AppColor._();

  /// Brand colour. Everything else in this file is either derived from it or
  /// semantic (success / danger / warning).
  static const Color primary = Color(0xFF995043);

  /// Pressed states and text that sits on a light tint.
  static const Color primaryDark = Color(0xFF7A3F35);

  /// Surfaces behind primary content — avatars, chips, empty states.
  static const Color primaryLight = Color(0xFFB37065);

  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFECFDF5);

  static const Color danger = Color(0xFFDC2626);
  static const Color dangerLight = Color(0xFFFEF2F2);

  static const Color warning = Color(0xFFFF9800);

  static const Color background = Color(0xFFFFF8E1);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);

  static const Color textPrimary = Color(0xFF3E2723);
  static const Color textSecondary = Color(0xFF795548);
  static const Color textDisabled = Color(0xFF94A3B8);


  //បន្ថែមថ្មី
  static const Color error = Color(0xFFE53935);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFBCAAA4);
}