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

  String get _pinIcon => switch (entry.status) {
        TrackedSyncLogStatus.pending => AppAssetsSvg.trackedSyncPinPending,
        TrackedSyncLogStatus.failed => AppAssetsSvg.trackedSyncPinFailed,
        TrackedSyncLogStatus.synced => AppAssetsSvg.trackedSyncPinSynced,
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
          child: SvgPicture.asset(_pinIcon, width: 20.w, height: 20.w),
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
                  height: 20 / 14,
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
              AppAssetsSvg.trackedSyncSyncedCheck,
              width: 20.w,
              height: 20.w,
            ),
          )
        else
          TrackedSyncStatusPill(label: _statusLabel, color: _color),
      ],
    );
  }
}
