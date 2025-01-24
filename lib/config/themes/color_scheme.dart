import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

extension CustomColorScheme on ColorScheme {
  Color get textColor =>
      brightness == Brightness.light ? AppColors.midnightBlue : AppColors.white;

  Color get itemColor => brightness == Brightness.light
      ? AppColors.white
      : AppColors.backgroundDark;

  Color get bottomNavBarColor => brightness == Brightness.light
      ? AppColors.bottomBarLight
      : AppColors.bottomBarDark;

  Color get topBgColor => brightness == Brightness.light
      ? AppColors.bgImageColor
      : AppColors.bottomBarDark;

  Color get appBarColor => brightness == Brightness.light
      ? AppColors.appBarLight
      : AppColors.appBarDark;

  Color get shimmerBaseColor => brightness == Brightness.light
      ? AppColors.shimmerColor
      : AppColors.backgroundDark;

  Color get shimmerHighColor =>
      brightness == Brightness.light ? AppColors.white : AppColors.appBarDark;
}
