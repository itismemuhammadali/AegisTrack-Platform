import '../../../../../core/utils/app_exports.dart';

class TrackedZoneMapPreview extends StatelessWidget {
  const TrackedZoneMapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    const green = AppColors.trackedZoneAllowedGreen;

    return ClipRRect(
      borderRadius: 24.circular,
      child: SizedBox(
        height: 240.h,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(AppAssetsPng.trackedHomeMapPreviewBg,
                fit: BoxFit.cover),
            Container(color: AppColors.trackedMapPreviewOverlay),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Same Figma marker as the home Live Map preview.
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
                    AppStrings.zoneStatusMapPreview,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      height: 20 / 14,
                      color: AppColors.signInDarkSubtitle,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 12.w,
              bottom: 16.h,
              child: Container(
                padding: AppInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.2),
                  borderRadius: 100.circular,
                  border: Border.all(color: green.withValues(alpha: 0.3)),
                ),
                child: Text(
                  AppStrings.zoneStatusInsideBoundary,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    height: 16 / 12,
                    color: green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
