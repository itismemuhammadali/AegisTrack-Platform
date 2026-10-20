import 'package:joshua_r_hughes/src/core/utils/app_exports.dart';

class AppThemeController extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isLightMode => themeMode == ThemeMode.light;

  void setLightMode(bool enabled) {
    final mode = enabled ? ThemeMode.light : ThemeMode.dark;
    if (themeMode == mode) return;
    themeMode = mode;
    notifyListeners();
  }
}

final appThemeControllerProvider = ChangeNotifierProvider<AppThemeController>(
  (ref) => AppThemeController(),
);
