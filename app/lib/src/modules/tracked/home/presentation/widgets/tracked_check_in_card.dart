import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracked_check_in_entity.dart';

class TrackedCheckInCard extends StatelessWidget {
  const TrackedCheckInCard({super.key, required this.checkIn});

  final TrackedCheckInEntity checkIn;

  (String, Color, String) get _style => switch (checkIn.status) {
        TrackedCheckInStatus.upcoming => (
            AppAssetsSvg.trackedCheckInUpcoming,
            AppColors.signInDarkSubtitle,
            AppStrings.checkInsUpcoming,
          ),
        TrackedCheckInStatus.completed => (
            AppAssetsSvg.trackedCheckInCompleted,
            AppColors.trackedZoneAllowedGreen,
            AppStrings.checkInsCompleted,
          ),
        TrackedCheckInStatus.missed => (
            AppAssetsSvg.trackedCheckInMissed,
            AppColors.trackedSosRed,
            AppStrings.checkInsMissed,
          ),
      };

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = _style;
    final isUpcoming = checkIn.status == TrackedCheckInStatus.upcoming;
    final captionStyle = context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      height: 16 / 12,
      color: AppColors.hintGray,
    );

    return Container(
      padding: AppInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 16.circular,
        border: Border.all(
          color: AppColors.primaryWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isUpcoming
                  ? AppColors.primaryWhite.withValues(alpha: 0.1)
                  : color.withValues(alpha: 0.1),
              borderRadius: 18.circular,
            ),
            child: SvgPicture.asset(icon, width: 16.w, height: 16.w),
          ),
          16.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      checkIn.time,
                      style: context.bodyMediumStyle?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        height: 20 / 14,
                        color: AppColors.primaryWhite,
                      ),
                    ),
                    8.pw,
                    Text(checkIn.day, style: captionStyle),
                  ],
                ),
                2.ph,
                Text(checkIn.detail, style: captionStyle),
              ],
            ),
          ),
          Container(
            padding: AppInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: 14.circular,
            ),
            child: Text(
              label,
              style: captionStyle?.copyWith(
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
