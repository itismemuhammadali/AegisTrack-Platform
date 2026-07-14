import '../../../../../core/utils/app_exports.dart';

class TrackedLogCaptureHeader extends StatelessWidget {
  const TrackedLogCaptureHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
      child: Padding(
        padding: AppInsets.symmetric(horizontal: 24, vertical: 12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: AppBackButton(),
            ),
            Text(
              AppStrings.trackedLogCaptureTitle,
              style: context.titleLargeStyle?.copyWith(
                color: AppColors.primaryWhite,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
