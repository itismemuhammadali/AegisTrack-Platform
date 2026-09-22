import '../../../../../core/utils/app_exports.dart';
import '../../../cases/domain/entities/tracker_case_entity.dart';
import '../../../cases/presentation/controller/tracker_cases_controller.dart';
import '../../../cases/presentation/views/tracker_cases_view.dart';
import '../../../home/presentation/views/tracker_home_view.dart';
import '../../../profile/presentation/views/tracker_profile_view.dart';
import '../../../users/presentation/views/tracker_users_view.dart';
import '../../domain/entities/tracker_tab_item_entity.dart';

class TrackerDashboardController extends ChangeNotifier with Buffers {
  int selectedIndex = 0;

  late final List<Widget> screens = [
    TrackerHomeView(
      onNotifications: openAlerts,
      onViewAllAlerts: openAlerts,
      onAlertSelected: (_) => openAlerts(),
      onSosDetails: openAlerts,
    ),
    TrackerUsersView(
      onNotifications: openAlerts,
      onUserSelected: (user) =>
          AppRouterGo.push(trackerUserDetailsView, extra: user),
    ),
    TrackerCasesView(
      onNotifications: openAlerts,
      onSosDetails: openSosSubject,
      onCaseSelected: openCase,
    ),
    TrackerProfileView(onLogout: logout, onAction: openProfileAction),
  ];

  final List<TrackerTabItemEntity> tabs = const [
    TrackerTabItemEntity(
      icon: AppAssetsSvg.trackerNavHome,
      label: AppStrings.trackerNavHome,
    ),
    TrackerTabItemEntity(
      icon: AppAssetsSvg.trackerNavUsers,
      label: AppStrings.trackerNavUsers,
    ),
    TrackerTabItemEntity(
      icon: AppAssetsSvg.trackerNavCases,
      label: AppStrings.trackerNavCases,
    ),
    TrackerTabItemEntity(
      icon: AppAssetsSvg.trackerNavProfile,
      label: AppStrings.trackerNavProfile,
    ),
  ];

  /// Every notification bell, the home alert cards and the View Alerts quick
  /// action land on the same alert centre.
  void openAlerts() => AppRouterGo.push(trackerNotificationsView);

  /// The profile rows that have a screen behind them; the rest stay inert
  /// rather than pushing a placeholder.
  void openProfileAction(String action) => switch (action) {
        AppStrings.trackerHelpSupport =>
          AppRouterGo.push(trackerHelpSupportView),
        AppStrings.trackerPlanSubscription =>
          AppRouterGo.push(trackerPlanSubscriptionView),
        AppStrings.trackerEditProfile =>
          AppRouterGo.push(trackerEditProfileView),
        AppStrings.trackerEmailSettings =>
          AppRouterGo.push(trackerEmailSettingsView),
        _ => null,
      };

  void openCase(TrackerCaseEntity caseEntity) =>
      AppRouterGo.push(trackerCaseDetailView, extra: caseEntity);

  /// The Cases SOS card opens the unidentified subject's overview.
  void openSosSubject() => AppRouterGo.push(
        trackerUserDetailsView,
        extra: TrackerCasesController.sosSubject,
      );

  void onTabTapped(int index) {
    if (selectedIndex == index) return;
    selectedIndex = index;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthHandler.ref.logout();
    AppRouterGo.pushRemoveUntil(signInOptionsView);
  }

  bool isSelected(int index) => selectedIndex == index;
}

final trackerDashboardControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackerDashboardController>(
  (ref) => TrackerDashboardController(),
);
