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
        SizedBox(
          height: 200.h,
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
                      // Figma: 50.7×62.3 pin with a 21.7 dot centred in
                      // the pin's head (14.5 from top/left), 12.8 above text.
                      SizedBox(
                        width: 50.7.w,
                        height: 62.3.w,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              AppAssetsSvg.trackedHomeMapMarkerPin,
                              width: 50.7.w,
                              height: 62.3.w,
                            ),
                            Positioned(
                              left: 14.5.w,
                              top: 14.5.w,
                              child: SvgPicture.asset(
                                AppAssetsSvg.trackedHomeMapMarkerDot,
                                width: 21.7.w,
                                height: 21.7.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                      12.8.ph,
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
