import '../../../../../core/utils/app_exports.dart';
import 'tracker_live_status_pill.dart';

class TrackerLiveUserCard extends StatelessWidget {
  const TrackerLiveUserCard({
    super.key,
    required this.name,
    required this.initials,
    required this.isOnline,
  });

  final String name;
  final String initials;
  final bool isOnline;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: AppInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackerBorderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.trackerPurpleDeep,
              ),
              child: Text(
                initials,
                style: context.bodyMediumStyle?.copyWith(
                  fontSize: 14.sp,
                  height: 20 / 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -.15,
                  color: AppColors.primaryWhite,
                ),
              ),
            ),
            2.ph,
            Text(
              name,
              style: context.bodyMediumStyle?.copyWith(
                fontSize: 14.sp,
                height: 20 / 14,
                fontWeight: FontWeight.w600,
                letterSpacing: -.15,
                color: AppColors.viewerSignInText,
              ),
            ),
            Text(
              AppStrings.trackerMonitoredUser,
              style: context.bodySmallStyle?.copyWith(
                fontSize: 12.sp,
                height: 16 / 12,
                fontWeight: FontWeight.w400,
                color: AppColors.trackerAlertSubtitle,
              ),
            ),
            2.ph,
            isOnline
                ? const TrackerLiveStatusPill(
                    label: AppStrings.trackerStatusOnline,
                    color: AppColors.trackerOnlineGreen,
                    fill: AppColors.trackerOnlinePillFill,
                    border: AppColors.trackerOnlinePillBorder,
                  )
                : const TrackerLiveStatusPill(
                    label: AppStrings.trackerStatusOffline,
                    color: AppColors.trackerAmber,
                    fill: AppColors.trackerWarningSurface,
                    border: AppColors.trackerWarningBorder,
                  ),
          ],
        ),
      );
}
