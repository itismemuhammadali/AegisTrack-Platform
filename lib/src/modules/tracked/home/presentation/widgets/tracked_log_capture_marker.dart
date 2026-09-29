import '../../../../../core/utils/app_exports.dart';

class TrackedLogCaptureMarker extends StatelessWidget {
  const TrackedLogCaptureMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 100.w,
        height: 100.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned.fill(
              child: ColoredBox(
                color: AppColors.trackedLogDetailsCardBackground,
              ),
            ),
            Positioned.fill(
              child: ColoredBox(
                color: AppColors.trackedLogCaptureHeaderBackdrop.withValues(
                  alpha: 0.4,
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0, 0.5, 1],
                    colors: [
                      AppColors.onboardingScrimNavy.withValues(alpha: 0.08),
                      AppColors.onboardingScrimNavy.withValues(alpha: 0.18),
                      AppColors.onboardingScrimNavy.withValues(alpha: 0.08),
                    ],
                  ),
                ),
              ),
            ),
            SvgPicture.asset(
              AppAssetsSvg.trackedLogDetailsLocation,
              width: 60.sp,
              height: 60.sp,
            ),
          ],
        ),
      ),
    );
  }
}
