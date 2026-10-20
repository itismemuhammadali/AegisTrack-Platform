import '../../../../../core/utils/app_exports.dart';
import '../controller/tracked_home_controller.dart';

class TrackedReviewImageView extends ConsumerWidget {
  const TrackedReviewImageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedHomeControllerProvider);

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
                        AppStrings.reviewImageTitle,
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
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 500.h),
                      child: const _CapturedCard(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: AppInsets.only(left: 24, right: 24, bottom: 24),
                child: Column(
                  children: [
                    _ReviewButton(
                      icon: AppAssetsSvg.trackedReviewImageAttach,
                      label: AppStrings.reviewImageAttach,
                      isPrimary: true,
                      // Attach the photo to a new log (Add Note).
                      onTap: () =>
                          AppRouterGo.pushReplacement(trackedAddNoteView),
                    ),
                    16.ph,
                    _ReviewButton(
                      icon: AppAssetsSvg.trackedLiveMapRefresh,
                      label: AppStrings.reviewImageRetake,
                      onTap: controller.capturePhoto,
                    ),
                    16.ph,
                    _ReviewButton(
                      icon: AppAssetsSvg.trackedReviewImageDiscard,
                      label: AppStrings.reviewImageDiscard,
                      onTap: () {
                        controller.setPhoto(null);
                        AppRouterGo.back();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CapturedCard extends StatelessWidget {
  const _CapturedCard();

  @override
  Widget build(BuildContext context) {
    const green = AppColors.trackedZoneAllowedGreen;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 24.circular,
        border: Border.all(
          color: AppColors.primaryWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: green.withValues(alpha: 0.2),
              border: Border.all(color: green.withValues(alpha: 0.4)),
            ),
            child: SvgPicture.asset(
              AppAssetsSvg.trackedReviewImageCaptured,
              width: 40.w,
              height: 40.w,
            ),
          ),
          16.ph,
          Text(
            AppStrings.reviewImageCaptured,
            style: context.bodyLargeStyle?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 24 / 16,
              color: AppColors.primaryWhite,
            ),
          ),
          4.ph,
          Text(
            AppStrings.reviewImageHint,
            style: context.bodySmallStyle?.copyWith(
              fontSize: 12.sp,
              height: 16 / 12,
              color: AppColors.hintGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewButton extends StatelessWidget {
  const _ReviewButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: AppInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color:
              isPrimary ? null : AppColors.primaryWhite.withValues(alpha: 0.05),
          gradient: isPrimary
              ? const LinearGradient(
                  colors: AppColors.trackedQuickActionGradientColors,
                )
              : null,
          borderRadius: 16.circular,
          border: isPrimary
              ? null
              : Border.all(
                  color: AppColors.primaryWhite.withValues(alpha: 0.1),
                ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color:
                        AppColors.twoFactorAccentPurple.withValues(alpha: 0.3),
                    blurRadius: 3,
                    offset: Offset(0, 4.h),
                  ),
                  BoxShadow(
                    color:
                        AppColors.twoFactorAccentPurple.withValues(alpha: 0.3),
                    blurRadius: 7.5,
                    offset: Offset(0, 10.h),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, width: 20.w, height: 20.w),
            8.pw,
            Text(
              label,
              style: context.bodyLargeStyle?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                height: 24 / 16,
                color: AppColors.primaryWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
