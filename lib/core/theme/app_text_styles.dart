import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Styles for the Dark/Image Backgrounds (Landing Page)
  static const TextStyle landingTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.2,
  );

  static const TextStyle landingSubtitle = TextStyle(
    fontSize: 16,
    color: Colors.white70,
  );

  static const TextStyle landingHeader = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Styles for the Auth Cards
  static const TextStyle cardTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  // General semantic styles
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
}
