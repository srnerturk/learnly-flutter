import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  static TextStyle get displayLarge => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.15,
        letterSpacing: -0.5,
      );

  static TextStyle get displayMedium => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.2,
        letterSpacing: -0.3,
      );

  static TextStyle get titleLarge => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
      );

  static TextStyle get titleMedium => GoogleFonts.outfit(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleSmall => GoogleFonts.outfit(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.55,
      );

  static TextStyle get bodyMedium => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textTertiary,
        height: 1.4,
      );

  static TextStyle get labelLarge => GoogleFonts.outfit(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => GoogleFonts.outfit(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.2,
      );

  static TextStyle get labelSmall => GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.textTertiary,
        letterSpacing: 0.4,
      );
}
