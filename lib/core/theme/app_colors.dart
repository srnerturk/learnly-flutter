import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary: Electric Cyan
  static const primary = Color(0xFF00CFFF);
  static const primaryLight = Color(0x2200CFFF);
  static const primaryDark = Color(0xFF009ABF);

  // Accent: Vivid Orange (XP, energy)
  static const accent = Color(0xFFFF7A00);
  static const accentLight = Color(0x22FF7A00);

  // Gold (Streak, achievements)
  static const gold = Color(0xFFFFCC00);
  static const goldLight = Color(0x20FFCC00);

  // Success (correct, streaks)
  static const success = Color(0xFF00E676);
  static const successLight = Color(0x2000E676);

  // Error
  static const error = Color(0xFFFF4757);
  static const errorLight = Color(0x20FF4757);

  // Pro
  static const pro = Color(0xFFFFCC00);

  // Backgrounds — deep space dark
  static const background = Color(0xFF060912);
  static const surface = Color(0xFF0C1220);
  static const surfaceVariant = Color(0xFF111B30);
  static const surfaceElevated = Color(0xFF172038);

  // Text
  static const textPrimary = Color(0xFFE8F0FE);
  static const textSecondary = Color(0xFF8899BB);
  static const textTertiary = Color(0xFF4A5880);

  // Borders
  static const border = Color(0xFF1A2440);
  static const borderLight = Color(0xFF111B30);

  // Gradients
  static const List<Color> primaryGradient = [Color(0xFF00CFFF), Color(0xFF0070FF)];
  static const List<Color> accentGradient = [Color(0xFFFF7A00), Color(0xFFFF4500)];
  static const List<Color> goldGradient = [Color(0xFFFFCC00), Color(0xFFFF9500)];
  static const List<Color> successGradient = [Color(0xFF00E676), Color(0xFF00B09B)];
  static const List<Color> proGradient = [Color(0xFFFFCC00), Color(0xFFFF9500)];
  static const List<Color> cardHeroGradient = [Color(0xFF0070FF), Color(0xFF00CFFF)];
  static const List<Color> darkSurface = [Color(0xFF111B30), Color(0xFF0C1220)];
}
