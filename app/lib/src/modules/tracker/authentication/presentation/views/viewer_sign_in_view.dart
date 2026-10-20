import 'dart:math' as math;

import '../../../../../components/custom_textfield.dart';
import '../../../../../core/utils/app_exports.dart';
import '../../../../onboarding/presentation/widgets/onboarding_page_scaffold.dart';
import '../controller/viewer_auth_controller.dart';
import '../widgets/viewer_remember_me.dart';

/// Sign in for authorized viewers (tracker side).
class ViewerSignInView extends ConsumerWidget {
  const ViewerSignInView({
    super.key,
    this.onSignIn,
    this.onBiometrics,
    this.onForgotPassword,
    this.onRegister,
  });

  final void Function(String email)? onSignIn;
  final VoidCallback? onBiometrics;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onRegister;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(viewerAuthControllerProvider);
    final fieldFillColor = AppColors.primaryWhite.withValues(alpha: 0.05);
    final fieldBorderColor = AppColors.primaryWhite.withValues(alpha: 0.1);

    return Scaffold(
      backgroundColor: AppColors.onboardingScrimNavy,
      body: Stack(
        children: [
          const Positioned.fill(child: OnboardingPageBackground()),
          SafeArea(
            bottom: false,
            child: Form(
              key: controller.signInFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  24.ph,
                  Padding(
                    padding: AppInsets.symmetric(horizontal: 24),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: AppBackButton(),
                    ),
                  ),
                  24.ph,
                  Padding(
                    padding: AppInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.viewerSignInTitle,
                          style: context.headlineSmallStyle?.copyWith(
                            color: AppColors.primaryWhite,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        8.ph,
                        Text(
                          AppStrings.viewerSignInSubtitle,
                          style: context.bodyLargeStyle?.copyWith(
                            color: AppColors.signInDarkSubtitle,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            height: 24 / 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  24.ph,
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: controller.emailController,
                            hintText: AppStrings.email,
                            textInputType: TextInputType.emailAddress,
                            isPrefix: true,
                            prefixWidget: SvgPicture.asset(
                              AppAssetsSvg.signInEmailIcon,
                              width: 20.sp,
                              height: 20.sp,
                            ),
                            fillColor: fieldFillColor,
                            enableBorderColor: fieldBorderColor,
                            focusedBorderColor: fieldBorderColor,
                            validator: AppValidators.validateEmail,
                          ),
                          16.ph,
                          CustomTextField(
                            controller: controller.passwordController,
                            hintText: AppStrings.password,
                            isObscure: controller.obscurePassword,
                            isLast: true,
                            isPrefix: true,
                            prefixWidget: SvgPicture.asset(
                              AppAssetsSvg.signInPasswordIcon,
                              width: 20.sp,
                              height: 20.sp,
                            ),
                            suffixbutton: IconButton(
                              splashRadius: 20.r,
                              onPressed: controller.togglePasswordVisibility,
                              icon: Icon(
                                controller.obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.signInDarkSubtitle,
                                size: 20.sp,
                              ),
                            ),
                            fillColor: fieldFillColor,
                            enableBorderColor: fieldBorderColor,
                            focusedBorderColor: fieldBorderColor,
                            validator: AppValidators.validatePass,
                            onFieldSubmitted: (_) =>
                                controller.submitSignIn(onSuccess: onSignIn),
                          ),
                          24.ph,
                          Row(
                            children: [
                              Expanded(
                                child: ViewerRememberMe(
                                  value: controller.rememberMe,
                                  onTap: controller.toggleRememberMe,
                                ),
                              ),
                              GestureDetector(
                                onTap: onForgotPassword,
                                child: Text(
                                  AppStrings.forgotPassword,
                                  style: context.bodyMediumStyle?.copyWith(
                                    color: AppColors.primaryWhite,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 20 / 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          24.ph,
                          PrimaryAppButton(
                            text: AppStrings.viewerSignInTitle,
                            isLoading: controller.isSigningIn,
                            onTap: () =>
                                controller.submitSignIn(onSuccess: onSignIn),
                          ),
                          24.ph,
                          GestureDetector(
                            onTap: () => controller.signInWithBiometrics(
                              onSuccess: onBiometrics,
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: AppInsets.symmetric(
                                horizontal: 16,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                color: fieldFillColor,
                                borderRadius: 16.circular,
                                border: Border.all(color: fieldBorderColor),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AppAssetsSvg.trackerViewerBiometricsIcon,
                                    width: 20.w,
                                    height: 20.w,
                                  ),
                                  16.pw,
                                  Text(
                                    AppStrings.signInWithBiometrics,
                                    style: context.bodyLargeStyle?.copyWith(
                                      color: AppColors.viewerSignInText,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      height: 24 / 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      24.w,
                      0,
                      24.w,
                      math.max(32.h, MediaQuery.paddingOf(context).bottom),
                    ),
                    child: GestureDetector(
                      onTap: onRegister,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.dontHaveAccount,
                            style: context.bodyLargeStyle?.copyWith(
                              color: AppColors.signInDarkSubtitle,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              height: 24 / 16,
                            ),
                          ),
                          Text(
                            AppStrings.registerNow,
                            style: context.bodyLargeStyle?.copyWith(
                              color: AppColors.primaryWhite,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              height: 24 / 16,
                            ),
                          ),
                        ],
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
