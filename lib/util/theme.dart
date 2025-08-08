import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFF7F7F7);
  static const primaryText = Color(0xFF1D2D44);
  static const secondaryText = Color(0xFF747474);
  static const cardBackground = Color(0xFFFFFFFF);
  static const accent = Color(0xFF0A84FF);
  static const error = Color(0xFFD93F3F);
  static const divider = Color(0xFFEFEFEF);
}

class AppTextStyles {
  static const TextStyle screenTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );

  static const TextStyle sectionHeader = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.secondaryText,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  static const TextStyle secondaryBodyText = TextStyle(
    fontSize: 15,
    color: AppColors.secondaryText,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle menuLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );
}