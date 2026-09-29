import '../../../../../core/utils/app_exports.dart';

class TrackerTimelineStatsRow extends StatelessWidget {
  const TrackerTimelineStatsRow({
    super.key,
    required this.total,
    required this.verified,
    required this.flagged,
  });

  final String total;
  final String verified;
  final String flagged;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _TrackerTimelineStatTile(
                  value: total,
                  label: AppStrings.trackerTimelineTotal,
                  color: AppColors.primaryWhite),
            ),
            16.pw,
            Expanded(
              child: _TrackerTimelineStatTile(
                  value: verified,
                  label: AppStrings.trackerTimelineVerified,
                  color: AppColors.trackerOnlineGreen),
            ),
            16.pw,
            Expanded(
              child: _TrackerTimelineStatTile(
                  value: flagged,
                  label: AppStrings.trackerTimelineFlagged,
                  color: AppColors.trackerAmber),
            ),
          ],
        ),
      );
}

class _TrackerTimelineStatTile extends StatelessWidget {
  const _TrackerTimelineStatTile({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 20.circular,
          border: Border.all(color: AppColors.trackerBorderSoft),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: context.titleMediumStyle?.copyWith(
                  fontSize: 20.sp,
                  height: 28 / 20,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            Text(
              label,
              style: context.bodySmallStyle?.copyWith(
                fontSize: 12.sp,
                height: 16 / 12,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryWhite,
              ),
            ),
          ],
        ),
      );
}
