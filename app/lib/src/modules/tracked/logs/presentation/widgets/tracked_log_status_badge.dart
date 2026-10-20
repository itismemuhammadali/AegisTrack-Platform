import '../../../../../core/utils/app_exports.dart';

class TrackedLogStatusBadge extends StatelessWidget {
  const TrackedLogStatusBadge({super.key, required this.status});

  final TrackedLogStatus status;

  String get _icon => switch (status) {
    TrackedLogStatus.synced => AppAssetsSvg.trackedLogsStatusSyncedIcon,
    TrackedLogStatus.pending => AppAssetsSvg.trackedLogsStatusPendingIcon,
    TrackedLogStatus.failed => AppAssetsSvg.trackedLogsStatusFailedIcon,
  };

  String get _label => switch (status) {
    TrackedLogStatus.synced => AppStrings.logStatusSynced,
    TrackedLogStatus.pending => AppStrings.logStatusPending,
    TrackedLogStatus.failed => AppStrings.logStatusFailed,
  };

  Color get _color => switch (status) {
    TrackedLogStatus.synced => AppColors.trackedLogSyncedGreen,
    TrackedLogStatus.pending => AppColors.trackedLogPendingAmber,
    TrackedLogStatus.failed => AppColors.trackedLogFailedRed,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(_icon, width: 12.sp, height: 12.sp),
        4.pw,
        Text(
          _label,
          style: context.bodySmallStyle?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: _color,
          ),
        ),
      ],
    );
  }
}
