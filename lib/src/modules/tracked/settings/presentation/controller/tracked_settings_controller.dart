import '../../../../../core/utils/app_exports.dart';

class TrackedSettingsController extends ChangeNotifier with Buffers {
  bool backgroundTrackingEnabled = true;
  bool autoSyncEnabled = true;

  void setBackgroundTracking(bool value) {
    if (backgroundTrackingEnabled == value) return;
    backgroundTrackingEnabled = value;
    notifyListeners();
  }

  void setAutoSync(bool value) {
    if (autoSyncEnabled == value) return;
    autoSyncEnabled = value;
    notifyListeners();
  }
}

final trackedSettingsControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackedSettingsController>(
  (ref) => TrackedSettingsController(),
);
