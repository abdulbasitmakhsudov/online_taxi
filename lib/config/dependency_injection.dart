import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:online_taxi/core/app_preferences/app_pref.dart';

final di = GetIt.instance;

Future<void> initDependencies() async {
  di.registerLazySingleton(() => StorageModule.providePreferencesStorage());
  // await SharePref().init();
  //
  // di.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  // di.registerSingleton<StudentRepository>(StudentRepositoryImpl());
}

// final authRepository = di.get<AuthRepository>();
// final studentRepository = di.get<StudentRepository>();
class StorageModule {
  static Future<void> initBoxes() async {
    await Hive.openBox("preferences");
  }

  static AppPreferences providePreferencesStorage() {
    final box = Hive.box("preferences");
    return AppPreferences(box: box);
  }
}