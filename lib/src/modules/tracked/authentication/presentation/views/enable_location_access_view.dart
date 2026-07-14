import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/utils/app_exports.dart';
import '../../../../onboarding/presentation/widgets/onboarding_page_scaffold.dart';
import '../widgets/sign_in_primary_button.dart';

class EnableLocationAccessView extends StatelessWidget {
  const EnableLocationAccessView({super.key, this.onAllow, this.onNotNow});

  final VoidCallback? onAllow;
  final VoidCallback? onNotNow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingScrimNavy,
      body: Stack(
        children: [
          const Positioned.fill(child: OnboardingPageBackground()),
          SafeArea(
            child: Padding(
              padding: AppInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 128.w,
                      height: 128.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryWhite.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryWhite.withValues(alpha: 0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.onboardingPurpleGradientStart
                                .withValues(alpha: 0.5),
                            blurRadius: 83,
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        AppAssetsSvg.locationPermissionShieldIcon,
                        width: 56.w,
                        height: 56.w,
                      ),
                    ),
                  ),
                  24.ph,
                  Text(
                    AppStrings.enableLocationAccessTitle,
                    textAlign: TextAlign.center,
                    style: context.headlineMediumStyle?.copyWith(
                      color: AppColors.primaryWhite,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      height: 36 / 30,
                    ),
                  ),
                  24.ph,
                  Text(
                    AppStrings.enableLocationAccessSubtitle,
                    textAlign: TextAlign.center,
                    style: context.bodyLargeStyle?.copyWith(
                      color: AppColors.signInDarkSubtitle,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      height: 26 / 16,
                    ),
                  ),
                  24.ph,
                  SignInPrimaryButton(
                    text: AppStrings.allowLocation,
                    onTap: () async {
                      await Permission.locationWhenInUse.request();
                      onAllow?.call();
                    },
                  ),
                  16.ph,
                  GestureDetector(
                    onTap: onNotNow,
                    child: Text(
                      AppStrings.notNow,
                      textAlign: TextAlign.center,
                      style: context.bodyMediumStyle?.copyWith(
                        color: AppColors.signInDarkSubtitle,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        height: 20 / 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
