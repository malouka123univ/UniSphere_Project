import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const String headlineFont = 'PublicSans';
  static const String bodyFont = 'Inter';

  static TextStyle get headlineSmall => const TextStyle(
        fontFamily: headlineFont,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.01,
        color: AppColors.onSurface,
        height: 1.3,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontFamily: bodyFont,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
        height: 1.4,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
        height: 1.5,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.05,
        color: AppColors.onSurface,
        height: 1.4,
      );

  static TextStyle get labelSmall => const TextStyle(
        fontFamily: bodyFont,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        height: 1.4,
      );
}