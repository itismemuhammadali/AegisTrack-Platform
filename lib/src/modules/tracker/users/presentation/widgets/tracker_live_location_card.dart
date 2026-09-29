import '../../../../../core/utils/app_exports.dart';

class TrackerLiveLocationCard extends StatelessWidget {
  const TrackerLiveLocationCard({
    super.key,
    required this.location,
    required this.coordinates,
    required this.updated,
    required this.isOnline,
  });

  final String location;
  final String coordinates;
  final String updated;
  final bool isOnline;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackerBorderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location,
              style: context.titleMediumStyle?.copyWith(
                fontSize: 18.sp,
                height: 28 / 18,
                fontWeight: FontWeight.w600,
                letterSpacing: -.44,
                color: AppColors.viewerSignInText,
              ),
            ),
            4.ph,
            Text(
              coordinates,
              style: context.bodyMediumStyle?.copyWith(
                fontSize: 14.sp,
                height: 20 / 14,
                fontFamily: 'monospace',
                color: AppColors.primaryWhite,
              ),
            ),
            12.ph,
            Row(
              children: [
                SvgPicture.asset(AppAssetsSvg.trackerLiveRefresh,
                    width: 16.w, height: 16.w),
                8.pw,
                Expanded(
                  child: Text(
                    '${AppStrings.trackerLastUpdated}$updated',
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      height: 20 / 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -.15,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                ),
                8.pw,
                SvgPicture.asset(
                  AppAssetsSvg.trackerLiveSignal,
                  width: 16.w,
                  height: 16.w,
                  // The bars ship green; tint them when the signal is gone.
                  colorFilter: isOnline
                      ? null
                      : const ColorFilter.mode(
                          AppColors.trackerAmber, BlendMode.srcIn),
                ),
                6.pw,
                Text(
                  isOnline
                      ? AppStrings.trackerSignalStrong
                      : AppStrings.trackerSignalNone,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    height: 16 / 12,
                    fontWeight: FontWeight.w400,
                    color: isOnline
                        ? AppColors.trackerOnlineGreen
                        : AppColors.trackerAmber,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
