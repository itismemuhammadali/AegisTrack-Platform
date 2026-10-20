import '../../../../core/utils/app_exports.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
  });

  final int pageCount;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentPage;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: isActive ? 8.h : 10.h,
            width: isActive ? 32.w : 10.w,
            decoration: BoxDecoration(
              borderRadius: 100.circular,
              color: isActive ? null : AppColors.onboardingDotInactive,
              gradient: isActive
                  ? const LinearGradient(
                      colors: AppColors.onboardingIndicatorGradientColors,
                      stops: AppColors.onboardingIndicatorGradientStops,
                    )
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
