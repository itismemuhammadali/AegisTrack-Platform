import 'dart:math' as math;

import '../../../../../components/custom_textfield.dart';
import '../../../../../core/utils/app_exports.dart';
import '../../../../onboarding/presentation/widgets/onboarding_page_scaffold.dart';
import '../controller/auth_controller.dart';
import '../widgets/sign_in_primary_button.dart';
import '../widgets/sign_in_social_button.dart';

class SignInView extends HookConsumerWidget {
  const SignInView({
    super.key,
    this.onSignIn,
    this.onGoogleSignIn,
    this.onAppleSignIn,
    this.onFacebookSignIn,
    this.onContactSupport,
  });

  final void Function(String email, String password)? onSignIn;
  final VoidCallback? onGoogleSignIn;
  final VoidCallback? onAppleSignIn;
  final VoidCallback? onFacebookSignIn;
  final VoidCallback? onContactSupport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);

    final fieldFillColor = AppColors.primaryWhite.withValues(alpha: 0.05);
    final fieldBorderColor = AppColors.primaryWhite.withValues(alpha: 0.1);

    void submit() {
      if (formKey.currentState?.validate() ?? false) {
        final email = emailController.text;
        final password = passwordController.text;
        authController.signIn(
          email: email,
          password: password,
          onSuccess: () => onSignIn?.call(email, password),
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.onboardingScrimNavy,
      body: Stack(
        children: [
          const Positioned.fill(child: OnboardingPageBackground()),
          SafeArea(
            bottom: false,
            child: Form(
              key: formKey,
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
                            controller: emailController,
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
                            controller: passwordController,
                            hintText: AppStrings.password,
                            isObscure: obscurePassword.value,
                            isLast: true,
                            isPrefix: true,
                            prefixWidget: SvgPicture.asset(
                              AppAssetsSvg.signInPasswordIcon,
                              width: 20.sp,
                              height: 20.sp,
                            ),
                            suffixbutton: IconButton(
                              splashRadius: 20.r,
                              onPressed: () => obscurePassword.value =
                                  !obscurePassword.value,
                              icon: Icon(
                                obscurePassword.value
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
                            onFieldSubmitted: (_) => submit(),
                          ),
                          24.ph,
                          SignInPrimaryButton(
                            text: AppStrings.signIn,
                            onTap: submit,
                            isLoading: authController.isSigningIn,
                          ),
                          24.ph,
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: AppInsets.symmetric(horizontal: 16),
                                child: Text(
                                  AppStrings.or,
                                  style: context.bodySmallStyle?.copyWith(
                                    color: AppColors.coolGray,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          10.ph,
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
                      onTap: onContactSupport,
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
                            AppStrings.contactWithSupports,
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
