import '../../../../../core/utils/app_exports.dart';

/// Gradient "Sign in" button — shares the exact gradient, shadow and radius
/// tokens the onboarding "Get Started" button uses (per Figma), just without
/// its trailing arrow and with a centered label instead.
class SignInPrimaryButton extends StatelessWidget {
  const SignInPrimaryButton({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: AppInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: 16.circular,
          gradient: const LinearGradient(
            colors: AppColors.onboardingButtonGradientColors,
            stops: AppColors.onboardingButtonGradientStops,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.onboardingPurpleGradientStart.withValues(
                alpha: 0.3,
              ),
              blurRadius: 3,
              offset: Offset(0, 4.h),
            ),
            BoxShadow(
              color: AppColors.onboardingPurpleGradientStart.withValues(
                alpha: 0.3,
              ),
              blurRadius: 7.5,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Text(
          text,
          style: context.bodyLargeStyle?.copyWith(
            color: AppColors.primaryWhite,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
