import 'dart:math' as math;

import '../../../../../core/utils/app_exports.dart';
import '../../../../onboarding/presentation/widgets/onboarding_page_scaffold.dart';
import '../widgets/sign_in_social_button.dart';

/// First sign-in screen: social sign-in, email sign-in and viewer access.
class SignInOptionsView extends StatelessWidget {
  const SignInOptionsView({
    super.key,
    this.onGoogleSignIn,
    this.onAppleSignIn,
    this.onFacebookSignIn,
    this.onEmailSignIn,
    this.onViewerAccount,
  });

  final VoidCallback? onGoogleSignIn;
  final VoidCallback? onAppleSignIn;
  final VoidCallback? onFacebookSignIn;
  final VoidCallback? onEmailSignIn;
  final VoidCallback? onViewerAccount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingScrimNavy,
      body: Stack(
        children: [
          const Positioned.fill(child: OnboardingPageBackground()),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                24.ph,
                Column(
                  children: [
                    Text(
                      AppStrings.welcomeBack,
                      style: context.headlineSmallStyle?.copyWith(
                        color: AppColors.primaryWhite,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    8.ph,
                    Text(
                      AppStrings.signInSubtitle,
                      style: context.bodyLargeStyle?.copyWith(
                        color: AppColors.signInDarkSubtitle,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        height: 24 / 16,
                      ),
                    ),
                  ],
                ),
                24.ph,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      24.w,
                      0,
                      24.w,
                      math.max(32.h, MediaQuery.paddingOf(context).bottom),
                    ),
                    child: Column(
                      children: [
                        SignInSocialButton(
                          icon: AppAssetsSvg.signInGoogleIcon,
                          text: AppStrings.continueWithGoogle,
                          onTap: () => onGoogleSignIn?.call(),
                        ),
                        16.ph,
                        SignInSocialButton(
                          icon: AppAssetsSvg.signInAppleIcon,
                          text: AppStrings.continueWithApple,
                          onTap: () => onAppleSignIn?.call(),
                        ),
                        16.ph,
                        SignInSocialButton(
                          icon: AppAssetsSvg.signInFacebookIcon,
                          text: AppStrings.continueWithFacebook,
                          onTap: () => onFacebookSignIn?.call(),
                        ),
                        24.ph,
                        Row(
                          children: [
                            const Expanded(child: _OrLine()),
                            Padding(
                              padding: AppInsets.symmetric(horizontal: 16),
                              child: Text(
                                AppStrings.signInOr,
                                style: context.bodyMediumStyle?.copyWith(
                                  color: AppColors.primaryWhite
                                      .withValues(alpha: 0.6),
                                  fontSize: 14.sp,
                                  height: 20 / 14,
                                ),
                              ),
                            ),
                            const Expanded(child: _OrLine()),
                          ],
                        ),
                        24.ph,
                        PrimaryAppButton(
                          text: AppStrings.signInWithEmail,
                          onTap: () => onEmailSignIn?.call(),
                        ),
                        24.ph,
                        GestureDetector(
                          onTap: onViewerAccount,
                          child: Container(
                            width: double.infinity,
                            padding: AppInsets.symmetric(vertical: 16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.primaryWhite
                                  .withValues(alpha: 0.05),
                              borderRadius: 16.circular,
                              border: Border.all(
                                color: AppColors.primaryWhite
                                    .withValues(alpha: 0.1),
                              ),
                            ),
                            child: Text(
                              AppStrings.continueAsViewer,
                              style: context.bodyLargeStyle?.copyWith(
                                color: AppColors.primaryWhite,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                height: 24 / 16,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 320.w,
                          child: Text(
                            AppStrings.signInTerms,
                            textAlign: TextAlign.center,
                            style: context.bodyLargeStyle?.copyWith(
                              color: AppColors.signInDarkSubtitle,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              height: 24 / 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrLine extends StatelessWidget {
  const _OrLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppColors.primaryWhite.withValues(alpha: 0.6),
    );
  }
}
