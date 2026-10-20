import '../../../../../core/utils/app_exports.dart';
import '../controller/tracked_settings_controller.dart';
import '../widgets/tracked_sync_status_log_card.dart';
import '../widgets/tracked_sync_status_log_row.dart';
import '../widgets/tracked_sync_status_retry_button.dart';
import '../widgets/tracked_sync_status_section_heading.dart';
import '../widgets/tracked_sync_status_stat_card.dart';

class TrackedSyncStatusView extends ConsumerWidget {
  const TrackedSyncStatusView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedSettingsControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.trackedDashboardBackground,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 0.5, 1],
            colors: [
              AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
              AppColors.onboardingScrimNavy.withValues(alpha: 0.9),
              AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppInsets.only(left: 24, right: 24, top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const AppBackButton(),
                    Expanded(
                      child: Text(
                        AppStrings.trackedSettingsSyncStatus,
                        textAlign: TextAlign.center,
                        style: context.titleLargeStyle?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          height: 28 / 20,
                          color: AppColors.primaryWhite,
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: controller.syncNow,
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryWhite.withValues(alpha: 0.05),
                          borderRadius: 18.circular,
                          border: Border.all(
                            color:
                                AppColors.primaryWhite.withValues(alpha: 0.1),
                          ),
                        ),
                        child: SvgPicture.asset(
                          AppAssetsSvg.trackedSyncRefresh,
                          width: 20.w,
                          height: 20.w,
                        ),
                      ),
                    ),
                  ],
                ),
                24.ph,
                Expanded(
                  child: ListView(
                    padding: AppInsets.only(bottom: 24),
                    children: [
                      Row(
                        children: [
                          TrackedSyncStatusStatCard(
                            icon: AppAssetsSvg.trackedSyncStatPending,
                            label: AppStrings.logStatusPending,
                            count: controller.pendingEntries.length,
                          ),
                          12.pw,
                          TrackedSyncStatusStatCard(
                            icon: AppAssetsSvg.trackedSyncStatFailed,
                            label: AppStrings.logStatusFailed,
                            count: controller.failedEntries.length,
                          ),
                          12.pw,
                          TrackedSyncStatusStatCard(
                            icon: AppAssetsSvg.trackedSyncStatSynced,
                            label: AppStrings.logStatusSynced,
                            count: controller.syncedEntries.length,
                          ),
                        ],
                      ),
                      if (controller.pendingEntries.isNotEmpty) ...[
                        24.ph,
                        TrackedSyncStatusSectionHeading(
                          icon: AppAssetsSvg.trackedSyncHeadingPending,
                          label: AppStrings.trackedSyncStatusPendingLogs,
                        ),
                        12.ph,
                        for (final entry in controller.pendingEntries) ...[
                          TrackedSyncStatusLogCard(
                            borderColor:
                                AppColors.primaryWhite.withValues(alpha: 0.1),
                            child: TrackedSyncStatusLogRow(entry: entry),
                          ),
                          if (entry != controller.pendingEntries.last) 10.ph,
                        ],
                      ],
                      if (controller.failedEntries.isNotEmpty) ...[
                        24.ph,
                        TrackedSyncStatusSectionHeading(
                          icon: AppAssetsSvg.trackedSyncHeadingFailed,
                          label: AppStrings.trackedSyncStatusFailedLogs,
                        ),
                        12.ph,
                        TrackedSyncStatusLogCard(
                          borderColor: AppColors.trackedLogFailedRed
                              .withValues(alpha: 0.2),
                          child: Column(
                            children: [
                              for (final entry in controller.failedEntries) ...[
                                TrackedSyncStatusLogRow(entry: entry),
                                10.ph,
                                TrackedSyncStatusRetryButton(
                                  onTap: () => controller.retrySync(entry),
                                ),
                                if (entry != controller.failedEntries.last)
                                  16.ph,
                              ],
                            ],
                          ),
                        ),
                      ],
                      if (controller.syncedEntries.isNotEmpty) ...[
                        24.ph,
                        TrackedSyncStatusSectionHeading(
                          icon: AppAssetsSvg.trackedSyncSyncedCheck,
                          label: AppStrings.trackedSyncStatusSyncedLogs,
                        ),
                        12.ph,
                        for (final entry in controller.syncedEntries) ...[
                          TrackedSyncStatusLogCard(
                            borderColor:
                                AppColors.primaryWhite.withValues(alpha: 0.1),
                            child: TrackedSyncStatusLogRow(entry: entry),
                          ),
                          if (entry != controller.syncedEntries.last) 10.ph,
                        ],
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
