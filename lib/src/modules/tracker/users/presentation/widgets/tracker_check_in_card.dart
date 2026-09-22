import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_check_in_entity.dart';

class TrackerCheckInCard extends StatelessWidget {
  const TrackerCheckInCard({super.key, required this.checkIn, this.onTap});

  final TrackerCheckInEntity checkIn;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final detailStyle = context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      height: 16 / 12,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryWhite,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 16.circular,
          border: Border.all(
              color: checkIn.status.cardBorder ?? AppColors.trackerBorderSoft),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppInsets.only(top: 2),
              child: SvgPicture.asset(checkIn.status.icon,
                  width: 20.w, height: 20.w),
            ),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // A Wrap rather than a Row: at the design's width the tag
                  // sits beside the title, and on narrower screens it drops
                  // to its own line instead of truncating the title.
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 4.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        checkIn.title,
                        style: context.bodyMediumStyle?.copyWith(
                          fontSize: 14.sp,
                          height: 20 / 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -.15,
                          color: AppColors.viewerSignInText,
                        ),
                      ),
                      if (checkIn.hasEscalatedTag)
                        Container(
                          padding:
                              AppInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.trackerDangerPillFill,
                            borderRadius: 4.circular,
                            border: Border.all(
                                color: AppColors.trackerDangerPillBorder),
                          ),
                          child: Text(
                            AppStrings.trackerEscalatedTag,
                            style: context.bodySmallStyle?.copyWith(
                              fontSize: 12.sp,
                              height: 16 / 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: .3,
                              color: AppColors.trackerFlaggedRed,
                            ),
                          ),
                        ),
                    ],
                  ),
                  2.ph,
                  Text(checkIn.schedule,
                      style: detailStyle, overflow: TextOverflow.ellipsis),
                  2.ph,
                  Text(checkIn.detail,
                      style: detailStyle, overflow: TextOverflow.ellipsis),
                  if (checkIn.hasPhoto) ...[
                    8.ph,
                    Row(
                      children: [
                        SvgPicture.asset(AppAssetsSvg.trackerTimelinePhoto,
                            width: 12.w, height: 12.w),
                        6.pw,
                        Expanded(
                          child: Text(AppStrings.trackerPhotoAvailable,
                              style: detailStyle),
                        ),
                      ],
                    ),
                  ],
                  if (checkIn.note != null) ...[
                    8.ph,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: AppInsets.only(top: 2),
                          child: SvgPicture.asset(
                              AppAssetsSvg.trackerCheckInGrace,
                              width: 12.w,
                              height: 12.w),
                        ),
                        6.pw,
                        Expanded(
                          child: Text(
                            checkIn.note!,
                            style: detailStyle?.copyWith(
                                color: AppColors.trackerAmber),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            8.pw,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: checkIn.status.fill,
                    borderRadius: 16.circular,
                    border: Border.all(color: checkIn.status.border),
                  ),
                  child: Text(
                    checkIn.status.label,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      height: 16 / 12,
                      fontWeight: FontWeight.w600,
                      color: checkIn.status.color,
                    ),
                  ),
                ),
                8.ph,
                SvgPicture.asset(AppAssetsSvg.trackerTimelineChevron,
                    width: 16.w, height: 16.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
