import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:online_taxi/config/themes/color_scheme.dart';
import 'package:online_taxi/core/constants/app_colors.dart';
import 'package:online_taxi/core/widgets/primary_button.dart';

import '../constants/app_fonts.dart';

class UnderSaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const UnderSaveButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Card(
        margin: const EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        elevation: 0,
        child: Container(
            height: 156,
            alignment: const Alignment(0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              color: Theme.of(context).colorScheme.appBarColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Light shadow
                  blurRadius: 10, // Blur effect
                  spreadRadius: 5, // Spread of the shadow
                  offset:
                      const Offset(0, -5), // Position of shadow (move upwards)
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                8.verticalSpace,
                Text(
                  "Have you arrived?",
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: pmedium.copyWith(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.textColor),
                ),
                24.verticalSpace,
                PrimaryButton(
                  color: AppColors.primary,
                  onTap: onPressed,
                  text: title.tr,
                ),
              ],
            )),
      ),
    );
  }
}
