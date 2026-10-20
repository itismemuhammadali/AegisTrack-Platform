import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';

class TrackerCaseSosCard extends StatelessWidget {
  const TrackerCaseSosCard({
    super.key,
    required this.name,
    required this.initials,
    required this.location,
    required this.time,
    this.onTap,
  });

  final String name;
  final String initials;
  final String location;
  final String time;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = context.bodySmallStyle
        ?.copyWith(fontSize: 12.sp, color: AppColors.trackerAlertSubtitle);
    return GestureDetector(
      onTap: onTap,
      child: TrackerSurface(
        borderColor: AppColors.trackerCriticalRed,
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.trackerPurpleDeep.withValues(alpha: .5),
              ),
              child: Text(
                initials,
                style: context.bodyMediumStyle
                    ?.copyWith(fontSize: 14.sp, color: AppColors.primaryWhite),
              ),
            ),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.primaryWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  4.ph,
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssetsSvg.trackerUserLocation,
                        width: 12.w,
                        height: 12.w,
                        colorFilter: const ColorFilter.mode(
                            AppColors.trackerAlertSubtitle, BlendMode.srcIn),
                      ),
                      4.pw,
                      Expanded(child: Text(location, style: subtitleStyle)),
                    ],
                  ),
                  3.ph,
                  Text(time, style: subtitleStyle),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const TrackerBadge(AppStrings.trackerSosAlert,
                    background: AppColors.trackerCriticalRed),
                6.ph,
                const TrackerBadge(AppStrings.trackerVerifiedBadge,
                    color: AppColors.trackerOnlineGreen),
                8.ph,
                SvgPicture.asset(AppAssetsSvg.trackerAlertChevron,
                    width: 16.w, height: 16.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
