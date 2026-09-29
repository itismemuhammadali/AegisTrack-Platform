import 'dart:math' as math;

import '../../../../../components/custom_textfield.dart';
import '../../../../../core/utils/app_exports.dart';
import '../../../../onboarding/presentation/widgets/onboarding_page_scaffold.dart';
import '../controller/auth_controller.dart';

class SignInView extends HookConsumerWidget {
  const SignInView({
    super.key,
    this.onSignIn,
    this.onRegister,
  });

  final void Function(String email, String password)? onSignIn;
  final VoidCallback? onRegister;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);
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
              key: authController.signInFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  24.ph,
                  Padding(
                    padding: AppInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                  ),
                  24.ph,
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: authController.emailController,
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
                            controller: authController.passwordController,
                            hintText: AppStrings.password,
                            isObscure: authController.obscurePassword,
                            isLast: true,
                            isPrefix: true,
                            prefixWidget: SvgPicture.asset(
                              AppAssetsSvg.signInPasswordIcon,
                              width: 20.sp,
                              height: 20.sp,
                            ),
                            suffixbutton: IconButton(
                              splashRadius: 20.r,
                              onPressed:
                                  authController.togglePasswordVisibility,
                              icon: Icon(
                                authController.obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.signInDarkSubtitle,
                                size: 20.sp,
                              ),
                            ),
                            fillColor: fieldFillColor,
                            enableBorderColor: fieldBorderColor,
                            focusedBorderColor: fieldBorderColor,
                            validator: (value) =>
                                AppValidators.validatePass(value),
                            onFieldSubmitted: (_) =>
                                authController.submitSignIn(
                              onSuccess: onSignIn,
                            ),
                          ),
                          24.ph,
                          PrimaryAppButton(
                            text: AppStrings.signIn,
                            onTap: () => authController.submitSignIn(
                              onSuccess: onSignIn,
                            ),
                            isLoading: authController.isSigningIn,
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
                      math.max(24.h, MediaQuery.paddingOf(context).bottom),
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
                            ),
                          ),
                          Text(
                            AppStrings.registerNow,
                            style: context.bodyLargeStyle?.copyWith(
                              color: AppColors.primaryWhite,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
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
