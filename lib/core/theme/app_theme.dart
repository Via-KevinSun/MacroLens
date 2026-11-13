import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.chartA,
        secondary: AppColors.emerald,
        error: AppColors.coral,
        surface: AppColors.darkSurface,
      ),
      textTheme: AppTypography.textTheme(base.textTheme),
    );
  }

  static ThemeData get light {
    final base = ThemeData(brightness: Brightness.light, useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.navy,
        secondary: AppColors.emerald,
        error: AppColors.coral,
        surface: AppColors.lightSurface,
      ),
      textTheme: AppTypography.textTheme(base.textTheme),
    );
  }
}
