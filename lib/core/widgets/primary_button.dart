import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_taxi/config/themes/color_scheme.dart';
import 'package:online_taxi/core/constants/app_colors.dart';
import 'package:online_taxi/core/constants/app_fonts.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color? color;

  const PrimaryButton(
      {super.key, required this.onTap, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      child: Container(
          height: 56.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color ?? Theme.of(context).primaryColor,
          ),
          padding: const EdgeInsets.all(14),
          child: Center(
            child: Text(
              text,
              style: pmedium.copyWith(
                  fontSize: 16,
                  color: color != null
                      ? Theme.of(context).colorScheme.textColor
                      : AppColors.white),
            ),
          )),
    );
  }
}
