import '../../../../../core/utils/app_exports.dart';

class TrackerCheckInsStatsRow extends StatelessWidget {
  const TrackerCheckInsStatsRow({
    super.key,
    required this.completed,
    required this.missed,
    required this.upcoming,
  });

  final String completed;
  final String missed;
  final String upcoming;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _TrackerCheckInStatTile(
                  value: completed,
                  label: AppStrings.trackerStatCompleted,
                  color: AppColors.trackerOnlineGreen),
            ),
            8.pw,
            Expanded(
              child: _TrackerCheckInStatTile(
                  value: missed,
                  label: AppStrings.trackerStatMissed,
                  color: AppColors.trackerFlaggedRed),
            ),
            8.pw,
            Expanded(
              child: _TrackerCheckInStatTile(
                  value: upcoming,
                  label: AppStrings.trackerStatUpcoming,
                  color: AppColors.trackerInfoBlue),
            ),
          ],
        ),
      );
}

class _TrackerCheckInStatTile extends StatelessWidget {
  const _TrackerCheckInStatTile({
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
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackerBorderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: context.titleMediumStyle?.copyWith(
                fontSize: 20.sp,
                height: 28 / 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -.45,
                color: color,
              ),
            ),
            2.ph,
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  height: 16 / 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryWhite,
                ),
              ),
            ),
          ],
        ),
      );
}
