import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracked_sync_log_entry_entity.dart';
import 'tracked_sync_status_pill.dart';

class TrackedSyncStatusLogRow extends StatelessWidget {
  const TrackedSyncStatusLogRow({super.key, required this.entry});

  final TrackedSyncLogEntryEntity entry;

  Color get _color => switch (entry.status) {
    TrackedSyncLogStatus.pending => AppColors.trackedLogPendingAmber,
    TrackedSyncLogStatus.failed => AppColors.trackedLogFailedRed,
    TrackedSyncLogStatus.synced => AppColors.trackedLogSyncedGreen,
  };

  String get _statusLabel => switch (entry.status) {
    TrackedSyncLogStatus.pending => AppStrings.logStatusPending,
    TrackedSyncLogStatus.failed => AppStrings.logStatusFailed,
    TrackedSyncLogStatus.synced => AppStrings.logStatusSynced,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppInsets.only(top: 2),
          child: SvgPicture.asset(
            AppAssetsSvg.trackedLogsLocationPinIcon,
            width: 20.sp,
            height: 20.sp,
            colorFilter: ColorFilter.mode(_color, BlendMode.srcIn),
          ),
        ),
        12.pw,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.coordinates,
                style: context.bodyMediumStyle?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryWhite,
                ),
              ),
              4.ph,
              Text(
                entry.timestamp,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.trackedLogTagText,
                ),
              ),
              if (entry.failureReason != null) ...[
                4.ph,
                Text(
                  '${AppStrings.trackedSyncStatusFailureReasonPrefix}${entry.failureReason}',
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.trackedLogFailedRed,
                  ),
                ),
              ],
            ],
          ),
        ),
        12.pw,
        if (entry.status == TrackedSyncLogStatus.synced)
          Padding(
            padding: AppInsets.only(top: 2),
            child: SvgPicture.asset(
              AppAssetsSvg.trackedSyncStatusSyncedBadgeIcon,
              width: 20.sp,
              height: 20.sp,
              colorFilter: ColorFilter.mode(_color, BlendMode.srcIn),
            ),
          )
        else
          TrackedSyncStatusPill(label: _statusLabel, color: _color),
      ],
    );
  }
}
