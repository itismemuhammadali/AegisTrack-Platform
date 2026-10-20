import '../../../../../core/utils/app_exports.dart';

class TrackedLogDetailsMapPreview extends StatelessWidget {
  const TrackedLogDetailsMapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: 24.circular,
      child: SizedBox(
        height: 240.h,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(AppAssetsSvg.trackedLogDetailsMap, fit: BoxFit.cover),
            const ColoredBox(color: AppColors.trackedMapPreviewOverlay),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AppAssetsSvg.trackedLogDetailsMapPin,
                      width: 69.5.w, height: 69.5.w),
                  9.ph,
                  Text(
                    AppStrings.mapPreview,
                    style: context.bodySmallStyle?.copyWith(
                      color: AppColors.trackedLogDetailsMutedText,
                      fontSize: 14.sp,
                      height: 20 / 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
