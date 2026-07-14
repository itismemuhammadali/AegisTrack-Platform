import '../../../../../core/utils/app_exports.dart';
import '../controller/tracked_settings_controller.dart';
import '../widgets/tracked_settings_logout_button.dart';
import '../widgets/tracked_settings_nav_row.dart';
import '../widgets/tracked_settings_profile_card.dart';
import '../widgets/tracked_settings_section_label.dart';
import '../widgets/tracked_settings_settings_card.dart';
import '../widgets/tracked_settings_toggle_row.dart';

class TrackedSettingsView extends ConsumerWidget {
  const TrackedSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedSettingsControllerProvider);

    return Padding(
      padding: AppInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.trackedSettingsTitle,
            style: context.headlineSmallStyle?.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryWhite,
            ),
          ),
          24.ph,
          Expanded(
            child: ListView(
              padding: AppInsets.only(bottom: 112),
              children: [
                TrackedSettingsSectionLabel(
                  AppStrings.trackedSettingsProfileSection,
                ),
                10.ph,
                const TrackedSettingsProfileCard(),
                24.ph,
                TrackedSettingsSectionLabel(
                  AppStrings.trackedSettingsTrackingSection,
                ),
                10.ph,
                TrackedSettingsSettingsCard(
                  children: [
                    TrackedSettingsToggleRow(
                      icon: AppAssetsSvg.trackedSettingsBackgroundTrackingIcon,
                      title: AppStrings.trackedSettingsBackgroundTracking,
                      subtitle:
                          AppStrings.trackedSettingsBackgroundTrackingSubtitle,
                      value: controller.backgroundTrackingEnabled,
                      onChanged: controller.setBackgroundTracking,
                    ),
                    TrackedSettingsToggleRow(
                      icon: AppAssetsSvg.trackedSettingsAutoSyncIcon,
                      title: AppStrings.trackedSettingsAutoSync,
                      subtitle: AppStrings.trackedSettingsAutoSyncSubtitle,
                      value: controller.autoSyncEnabled,
                      onChanged: controller.setAutoSync,
                    ),
                  ],
                ),
                24.ph,
                TrackedSettingsSectionLabel(
                  AppStrings.trackedSettingsDataSection,
                ),
                12.ph,
                TrackedSettingsSettingsCard(
                  children: [
                    TrackedSettingsNavRow(
                      icon: AppAssetsSvg.trackedSettingsSyncStatusIcon,
                      title: AppStrings.trackedSettingsSyncStatus,
                      subtitle: AppStrings.trackedSettingsSyncStatusSubtitle,
                      onTap: () => AppRouterGo.push(trackedSyncStatusView),
                    ),
                    TrackedSettingsNavRow(
                      icon: AppAssetsSvg.trackedSettingsExportCenterIcon,
                      title: AppStrings.trackedSettingsExportCenter,
                      subtitle: AppStrings.trackedSettingsExportCenterSubtitle,
                      onTap: () => AppRouterGo.push(trackedExportCenterView),
                    ),
                  ],
                ),
                24.ph,
                const TrackedSettingsLogoutButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
