import '../../../../../core/utils/app_exports.dart';

class TrackedLogCaptureLocationCard extends StatelessWidget {
  const TrackedLogCaptureLocationCard({super.key, required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: 16.circular,
        border: Border.all(color: AppColors.trackedLogDetailsCardBorder),
      ),
      child: ClipRRect(
        borderRadius: 16.circular,
        child: Stack(
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
            Padding(
              padding: AppInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: AppColors.onboardingButtonGradientColors,
                        stops: AppColors.onboardingButtonGradientStops,
                      ),
                    ),
                    child: SvgPicture.asset(
                      AppAssetsSvg.trackedLogDetailsLocation,
                      width: 20.sp,
                      height: 20.sp,
                    ),
                  ),
                  12.pw,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.trackedLogCaptureCurrentLocation,
                          style: context.bodyLargeStyle?.copyWith(
                            color: AppColors.primaryWhite,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        4.ph,
                        Text(
                          location,
                          style: context.bodyMediumStyle?.copyWith(
                            color: AppColors.trackedLogDetailsMutedText,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
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
