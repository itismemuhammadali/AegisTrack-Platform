import 'package:joshua_r_hughes/src/core/services/local_db_service/secure_storage.dart';
import 'package:joshua_r_hughes/src/core/utils/app_exports.dart';

final locator = GetIt.instance;

void setupLocator() {
  appPrint("***Setup Registry***");
  locator.registerLazySingleton<Prefs>(() => Prefs());
  locator.registerLazySingleton<Client>(() => Client());
  locator.registerLazySingleton<ApiService>(() => ApiService());
  locator.registerLazySingleton<BaseApiService>(() => locator<ApiService>());
  locator.registerLazySingleton(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(),
      iOptions: IOSOptions.defaultOptions,
    ),
  );
  locator.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );
  // locator.registerFactory<AuthRepository>(
  //   () => AuthRepositoryImpl(locator<BaseApiService>()),
  // );
}
