import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_taxi/config/routes/app_routes.dart';
import 'package:online_taxi/core/constants/app_colors.dart';
import 'package:online_taxi/core/extensions/common_extensions.dart';
import 'package:online_taxi/core/extensions/navigation_extension.dart';

/// {@template SplashScreen}
///
/// {@endtemplate}
class SplashScreen extends StatefulWidget {
  /// {@macro SplashScreen}
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigate();
    super.initState();
  }

  void navigate() async {
    await Future.delayed(Duration(seconds: 1));
    if (mounted) {
      pushReplacementScreen(context, AppRoutes.homeScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "splash_image".pngImage,
              height: 224.h,
            ),
          ],
        ),
      ),
    );
  }
}
