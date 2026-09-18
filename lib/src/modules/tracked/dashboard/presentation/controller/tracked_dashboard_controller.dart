import '../../../../../core/utils/app_exports.dart';
import '../../../home/presentation/views/tracked_home_view.dart';
import '../../../logs/presentation/views/tracked_logs_view.dart';
import '../../../settings/presentation/views/tracked_settings_view.dart';
import '../../domain/entities/tracked_tab_item_entity.dart';
import '../../../ai/presentation/views/tracked_ai_view.dart';

class TrackedDashboardController extends ChangeNotifier with Buffers {
  int selectedIndex = 0;

  final List<Widget> screens = [
    TrackedHomeView(
      onLogNow: () => AppRouterGo.push(trackedLogCaptureView),
      onAddNote: () => AppRouterGo.push(trackedAddNoteView),
      onCapture: () => AppRouterGo.push(trackedAddNoteView),
      onSos: () => AppRouterGo.push(trackedSosView),
      onZone: () => AppRouterGo.push(trackedZoneStatusView),
      onCheckIn: () => AppRouterGo.push(trackedCheckInsView),
    ),
    const TrackedLogsView(),
    const TrackedAiView(),
    const TrackedSettingsView(),
  ];

  final List<TrackedTabItemEntity> tabs = const [
    TrackedTabItemEntity(
      icon: AppAssetsSvg.trackedNavHomeIcon,
      activeIcon: AppAssetsSvg.trackedNavHomeActiveIcon,
      label: AppStrings.trackedNavHome,
    ),
    TrackedTabItemEntity(
      icon: AppAssetsSvg.trackedNavLogsIcon,
      activeIcon: AppAssetsSvg.trackedNavLogsActiveIcon,
      label: AppStrings.trackedNavLogs,
    ),
    TrackedTabItemEntity(
      icon: AppAssetsSvg.trackedNavAiIcon,
      activeIcon: AppAssetsSvg.trackedNavAiActiveIcon,
      label: AppStrings.trackedNavAi,
    ),
    TrackedTabItemEntity(
      icon: AppAssetsSvg.trackedNavSettingsIcon,
      activeIcon: AppAssetsSvg.trackedNavSettingsActiveIcon,
      label: AppStrings.trackedNavSettings,
    ),
  ];

  void onTabTapped(int index) {
    if (selectedIndex == index) return;
    selectedIndex = index;
    notifyListeners();
  }

  bool isSelected(int index) => selectedIndex == index;
}

final trackedDashboardControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackedDashboardController>(
  (ref) => TrackedDashboardController(),
);
