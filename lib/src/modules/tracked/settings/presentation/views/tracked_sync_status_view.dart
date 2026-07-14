import '../../../../../core/utils/app_exports.dart';
import '../controller/tracked_sync_status_controller.dart';
import '../widgets/tracked_sync_status_log_row.dart';
import '../widgets/tracked_sync_status_retry_button.dart';
import '../widgets/tracked_sync_status_stat_card.dart';

class TrackedSyncStatusView extends ConsumerWidget {
  const TrackedSyncStatusView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedSyncStatusControllerProvider);

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
            padding: AppInsets.symmetric(horizontal: 24, vertical: 16),
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
                          color: AppColors.primaryWhite,
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: controller.syncNow,
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryWhite.withValues(alpha: 0.05),
                          borderRadius: 18.circular,
                          border: Border.all(
                            color: AppColors.primaryWhite.withValues(alpha: 0.1),
                          ),
                        ),
                        child: SvgPicture.asset(
                          AppAssetsSvg.trackedSettingsSyncStatusIcon,
                          width: 20.sp,
                          height: 20.sp,
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
                            icon: AppAssetsSvg.trackedLogsStatusPendingIcon,
                            label: AppStrings.logStatusPending,
                            count: controller.pendingEntries.length,
                            color: AppColors.trackedLogPendingAmber,
                          ),
                          12.pw,
                          TrackedSyncStatusStatCard(
                            icon: AppAssetsSvg.trackedLogsStatusFailedIcon,
                            label: AppStrings.logStatusFailed,
                            count: controller.failedEntries.length,
                            color: AppColors.trackedLogFailedRed,
                          ),
                          12.pw,
                          TrackedSyncStatusStatCard(
                            icon: AppAssetsSvg.trackedLogsStatusSyncedIcon,
                            label: AppStrings.logStatusSynced,
                            count: controller.syncedEntries.length,
                            color: AppColors.trackedLogSyncedGreen,
                          ),
                        ],
                      ),
                      if (controller.pendingEntries.isNotEmpty) ...[
                        24.ph,
                        _SectionHeading(
                          icon: AppAssetsSvg.trackedLogsStatusPendingIcon,
                          label: AppStrings.trackedSyncStatusPendingLogs,
                          color: AppColors.trackedLogPendingAmber,
                        ),
                        12.ph,
                        for (final entry in controller.pendingEntries) ...[
                          _LogCard(
                            borderColor:
                                AppColors.primaryWhite.withValues(alpha: 0.1),
                            child: TrackedSyncStatusLogRow(entry: entry),
                          ),
                          if (entry != controller.pendingEntries.last) 10.ph,
                        ],
                      ],
                      if (controller.failedEntries.isNotEmpty) ...[
                        24.ph,
                        _SectionHeading(
                          icon: AppAssetsSvg.trackedLogsStatusFailedIcon,
                          label: AppStrings.trackedSyncStatusFailedLogs,
                          color: AppColors.trackedLogFailedRed,
                        ),
                        12.ph,
                        _LogCard(
                          borderColor:
                              AppColors.trackedLogFailedRed.withValues(alpha: 0.2),
                          child: Column(
                            children: [
                              for (final entry in controller.failedEntries) ...[
                                TrackedSyncStatusLogRow(entry: entry),
                                12.ph,
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
                        _SectionHeading(
                          icon: AppAssetsSvg.trackedLogsStatusSyncedIcon,
                          label: AppStrings.trackedSyncStatusSyncedLogs,
                          color: AppColors.trackedLogSyncedGreen,
                        ),
                        12.ph,
                        for (final entry in controller.syncedEntries) ...[
                          _LogCard(
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

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.icon,
    required this.label,
    required this.color,
  });

  final String icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 16.sp,
          height: 16.sp,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        8.pw,
        Text(
          label,
          style: context.bodyLargeStyle?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryWhite,
          ),
        ),
      ],
    );
  }
}

class _LogCard extends StatelessWidget {
  const _LogCard({required this.child, required this.borderColor});

  final Widget child;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 16.circular,
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}
