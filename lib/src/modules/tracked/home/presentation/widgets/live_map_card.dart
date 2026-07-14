import '../../../../../core/utils/app_exports.dart';

class LiveMapCard extends StatelessWidget {
  const LiveMapCard({super.key, this.onViewFullMap});

  final VoidCallback? onViewFullMap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.liveMap,
              style: context.titleMediumStyle?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryWhite,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onViewFullMap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppAssetsSvg.trackedHomeViewFullMapIcon,
                    width: 16.sp,
                    height: 16.sp,
                  ),
                  4.pw,
                  Text(
                    AppStrings.viewFullMap,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        16.ph,
        Expanded(
          child: ClipRRect(
            borderRadius: 24.circular,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  AppAssetsPng.trackedHomeMapPreviewBg,
                  fit: BoxFit.cover,
                ),
                Container(color: AppColors.trackedMapPreviewOverlay),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 50.w,
                        height: 62.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(
                              AppAssetsSvg.trackedHomeMapMarkerPin,
                              width: 50.w,
                              height: 62.h,
                            ),
                            SvgPicture.asset(
                              AppAssetsSvg.trackedHomeMapMarkerDot,
                              width: 22.w,
                              height: 22.h,
                            ),
                          ],
                        ),
                      ),
                      8.ph,
                      Text(
                        AppStrings.mapPreview,
                        style: context.bodyMediumStyle?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.signInDarkSubtitle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
