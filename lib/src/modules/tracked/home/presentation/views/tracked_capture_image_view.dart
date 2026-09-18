import '../../../../../core/utils/app_exports.dart';
import '../controller/tracked_home_controller.dart';

class TrackedCaptureImageView extends ConsumerWidget {
  const TrackedCaptureImageView({super.key, this.onCaptured});

  /// Called after a photo is taken (defaults to opening Review Image).
  final VoidCallback? onCaptured;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedHomeControllerProvider);

    Future<void> capture() async {
      if (await controller.capturePhoto()) {
        (onCaptured ?? () => AppRouterGo.push(trackedReviewImageView))();
      }
    }

    return Scaffold(
      backgroundColor: AppColors.trackedLogCaptureHeaderBackdrop,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 0.5, 1],
            colors: [
              AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
              AppColors.onboardingScrimNavy.withValues(alpha: 0.9),
              AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: AppInsets.only(left: 24, right: 24, top: 24),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: AppRouterGo.back,
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryWhite.withValues(alpha: 0.1),
                          borderRadius: 18.circular,
                          border: Border.all(
                            color:
                                AppColors.primaryWhite.withValues(alpha: 0.2),
                          ),
                        ),
                        child: SvgPicture.asset(
                          AppAssetsSvg.trackedLiveMapBack,
                          width: 20.w,
                          height: 20.w,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        AppStrings.captureImageTitle,
                        textAlign: TextAlign.center,
                        style: context.titleLargeStyle?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          height: 28 / 20,
                          color: AppColors.primaryWhite,
                        ),
                      ),
                    ),
                    40.pw,
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: AppInsets.all(24),
                  child: Center(
                    // Figma height 471; shrinks on short screens.
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 471.h),
                      child: const _Viewfinder(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: AppInsets.only(bottom: 24),
                child: GestureDetector(
                  onTap: capture,
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryWhite.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppColors.primaryWhite.withValues(alpha: 0.3),
                        width: 3.17,
                      ),
                    ),
                    child: Container(
                      width: 64.w,
                      height: 64.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Glass viewfinder with a rule-of-thirds grid and the camera-only hint.
class _Viewfinder extends StatelessWidget {
  const _Viewfinder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 24.circular,
        border: Border.all(
          color: AppColors.primaryWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Purple tint layered over the 5% white fill (Figma).
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.twoFactorAccentPurple.withValues(alpha: 0.1),
                  AppColors.twoFactorAccentPurple.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          // Figma: 3×3 cells, each with its own 1px 20%-white border, so
          // inner lines read doubled and the outer edge is outlined too.
          Column(
            children: [
              for (var row = 0; row < 3; row++)
                Expanded(
                  child: Row(
                    // Stretch so each empty cell fills the row height —
                    // otherwise the cells collapse and only horizontal
                    // lines are painted.
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var col = 0; col < 3; col++)
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primaryWhite
                                    .withValues(alpha: 0.2),
                                width: 1.057,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppAssetsSvg.trackedCaptureImageCamera,
                width: 80.w,
                height: 80.w,
              ),
              10.ph,
              Text(
                AppStrings.captureImageCameraOnly,
                style: context.bodyMediumStyle?.copyWith(
                  fontSize: 14.sp,
                  height: 20 / 14,
                  color: AppColors.signInDarkSubtitle,
                ),
              ),
              6.ph,
              Text(
                AppStrings.captureImageLightingHint,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  height: 16 / 12,
                  color: AppColors.hintGray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
