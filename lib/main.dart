import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:online_taxi/config/routes/app_routes.dart';
import 'package:online_taxi/core/app_preferences/app_pref.dart';

import 'config/dependency_injection.dart';
import 'config/themes/app_theme.dart';
import 'core/extensions/common_extensions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Hive.initFlutter();
  await StorageModule.initBoxes();
  await initDependencies();

  runApp(const AppWidget());
}

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final preferences = inject<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: preferences.themeListenable(),
      builder: (context, value, child) {
        return ScreenUtilInit(
          useInheritedMediaQuery: false,
          designSize: MediaQuery.sizeOf(context),
          builder: (context, child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Edu Track',
              themeMode: preferences.theme,
              theme: AppTheme.theme,
              darkTheme: AppTheme.darkTheme,
              fallbackLocale: const Locale('en', 'EN'),
              locale: Locale(preferences.lang ?? "en"),
              initialRoute: AppRoutes.splashScreen,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  child: child ?? Container(),
                );
              },
              onGenerateRoute: (settings) => AppRoutes.generateRoute(settings),
            );
          },
        );
      },
    );
  }
}
