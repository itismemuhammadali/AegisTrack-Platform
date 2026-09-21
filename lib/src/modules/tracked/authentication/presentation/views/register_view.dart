import '../../../../../components/custom_textfield.dart';
import '../../../../../core/utils/app_exports.dart';
import '../../../../onboarding/presentation/widgets/onboarding_page_scaffold.dart';
import '../controller/auth_controller.dart';

class RegisterView extends ConsumerWidget {
  const RegisterView({super.key, this.onRegister, this.onSignIn});

  final void Function(String email)? onRegister;
  final VoidCallback? onSignIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(authControllerProvider);
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
              key: controller.registerFormKey,
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
                          AppStrings.createAccount,
                          style: context.headlineMediumStyle?.copyWith(
                            color: AppColors.primaryWhite,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w600,
                            height: 40 / 32,
                          ),
                        ),
                        8.ph,
                        Text(
                          AppStrings.createAccountSubtitle,
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
                      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: controller.nameController,
                            hintText: AppStrings.fullName,
                            textInputType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            isPrefix: true,
                            prefixWidget: SvgPicture.asset(
                              AppAssetsSvg.signInPersonIcon,
                              width: 20.sp,
                              height: 20.sp,
                            ),
                            fillColor: fieldFillColor,
                            enableBorderColor: fieldBorderColor,
                            focusedBorderColor: fieldBorderColor,
                            validator: (value) => AppValidators.validateEmpty(
                              value,
                              AppStrings.fullName,
                            ),
                          ),
                          16.ph,
                          CustomTextField(
                            controller: controller.registerEmailController,
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
                            controller: controller.registerPasswordController,
                            hintText: AppStrings.password,
                            isObscure: controller.obscureRegisterPassword,
                            isPrefix: true,
                            prefixWidget: SvgPicture.asset(
                              AppAssetsSvg.signInPasswordIcon,
                              width: 20.sp,
                              height: 20.sp,
                            ),
                            suffixbutton: IconButton(
                              splashRadius: 20.r,
                              onPressed:
                                  controller.toggleRegisterPasswordVisibility,
                              icon: Icon(
                                controller.obscureRegisterPassword
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
                          ),
                          16.ph,
                          CustomTextField(
                            controller: controller.confirmPasswordController,
                            hintText: AppStrings.confirmPassword,
                            isObscure: controller.obscureConfirmPassword,
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
                                  controller.toggleConfirmPasswordVisibility,
                              icon: Icon(
                                controller.obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.signInDarkSubtitle,
                                size: 20.sp,
                              ),
                            ),
                            fillColor: fieldFillColor,
                            enableBorderColor: fieldBorderColor,
                            focusedBorderColor: fieldBorderColor,
                            validator: (value) => AppValidators.confirmPass(
                              value,
                              controller.registerPasswordController,
                            ),
                            onFieldSubmitted: (_) => controller.submitRegister(
                                onSuccess: onRegister),
                          ),
                          16.ph,
                          _TermsCheckbox(
                            value: controller.agreedToTerms,
                            onTap: controller.toggleTerms,
                          ),
                          24.ph,
                          PrimaryAppButton(
                            text: AppStrings.createAccount,
                            isLoading: controller.isRegistering,
                            onTap: () => controller.submitRegister(
                              onSuccess: onRegister,
                            ),
                          ),
                          24.ph,
                          GestureDetector(
                            onTap: onSignIn ?? AppRouterGo.back,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppStrings.alreadyHaveAccount,
                                  style: context.bodyLargeStyle?.copyWith(
                                    color: AppColors.signInDarkSubtitle,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 24 / 16,
                                  ),
                                ),
                                Text(
                                  AppStrings.signInAction,
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

class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({required this.value, required this.onTap});

  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = context.bodyMediumStyle?.copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      height: 20 / 14,
      color: AppColors.signInDarkSubtitle,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: value
                  ? AppColors.twoFactorAccentPurple
                  : AppColors.primaryWhite.withValues(alpha: 0.05),
            ),
            child: value
                ? Icon(
                    Icons.check_rounded,
                    size: 14.sp,
                    color: AppColors.primaryWhite,
                  )
                : null,
          ),
          10.pw,
          Expanded(
            child: Text.rich(
              TextSpan(
                text: AppStrings.agreeToTermsPrefix,
                style: style,
                children: [
                  TextSpan(
                    text: AppStrings.termsAndPrivacy,
                    style: style?.copyWith(color: AppColors.primaryWhite),
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
