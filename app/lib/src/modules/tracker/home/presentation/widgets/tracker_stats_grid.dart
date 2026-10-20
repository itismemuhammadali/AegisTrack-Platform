import '../../../../../core/utils/app_exports.dart';

class TrackerStatsGrid extends StatelessWidget {
  const TrackerStatsGrid({
    super.key,
    required this.trackedUsers,
    required this.activeAlerts,
    required this.syncRate,
    required this.missedCheckIns,
  });

  final String trackedUsers;
  final String activeAlerts;
  final String syncRate;
  final String missedCheckIns;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(
          _StatCard(
            icon: AppAssetsSvg.trackerStatUsers,
            label: AppStrings.trackerTrackedUsersStat,
            value: trackedUsers,
          ),
          _StatCard(
            icon: AppAssetsSvg.trackerStatAlerts,
            label: AppStrings.trackerActiveAlertsStat,
            value: activeAlerts,
          ),
        ),
        16.ph,
        _row(
          _StatCard(
            icon: AppAssetsSvg.trackerStatSync,
            label: AppStrings.trackerSyncRateStat,
            value: syncRate,
          ),
          _StatCard(
            icon: AppAssetsSvg.trackerStatMissed,
            label: AppStrings.trackerMissedCheckInsStat,
            value: missedCheckIns,
          ),
        ),
      ],
    );
  }

  Widget _row(Widget left, Widget right) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: left),
            16.pw,
            Expanded(child: right),
          ],
        ),
      );
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 16.circular,
        border: Border.all(
          color: AppColors.primaryWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, width: 16.w, height: 16.w),
              8.pw,
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.primaryWhite.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
          10.ph,
          Text(
            value,
            style: context.titleMediumStyle?.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryWhite,
            ),
          ),
        ],
      ),
    );
  }
}
