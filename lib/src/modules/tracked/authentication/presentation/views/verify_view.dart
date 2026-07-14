import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../../../../core/utils/app_exports.dart';
import '../../../../onboarding/presentation/widgets/onboarding_page_scaffold.dart';
import '../controller/auth_controller.dart';
import '../widgets/sign_in_primary_button.dart';

class VerifyView extends HookConsumerWidget {
  const VerifyView({
    super.key,
    required this.email,
    this.onVerify,
    this.onResend,
  });

  final String email;
  final void Function(String code)? onVerify;
  final VoidCallback? onResend;

  static const _codeLength = 6;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);
    useEffect(() {
      authController.startResendTimer();
      return null;
    }, const []);

    final fieldFillColor = AppColors.primaryWhite.withValues(alpha: 0.05);
    final fieldBorderColor = AppColors.primaryWhite.withValues(alpha: 0.1);
    const focusedFieldBorderColor = AppColors.authFocusedFieldBorder;

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
                Padding(
                  padding: AppInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const AppBackButton(),
                  ),
                ),
                24.ph,
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.verificationTitle,
                          style: context.headlineMediumStyle?.copyWith(
                            color: AppColors.primaryWhite,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w600,
                            height: 40 / 36,
                          ),
                        ),
                        Text(
                          AppStrings.verificationSubtitle,
                          style: context.bodyLargeStyle?.copyWith(
                            color: AppColors.signInDarkSubtitle,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            height: 24 / 16,
                          ),
                        ),
                        Text(
                          email,
                          style: context.bodyLargeStyle?.copyWith(
                            color: AppColors.primaryWhite,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            height: 24 / 16,
                          ),
                        ),
                        24.ph,
                        OtpTextField(
                          numberOfFields: _codeLength,
                          fieldWidth: 48.w,
                          fieldHeight: 56.h,
                          margin: EdgeInsets.zero,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          keyboardType: TextInputType.number,
                          showFieldAsBox: true,
                          filled: true,
                          fillColor: fieldFillColor,
                          borderWidth: 1.085,
                          borderRadius: BorderRadius.circular(16),
                          borderColor: fieldBorderColor,
                          enabledBorderColor: fieldBorderColor,
                          focusedBorderColor: focusedFieldBorderColor,
                          disabledBorderColor: fieldBorderColor,
                          contentPadding: EdgeInsets.zero,
                          textStyle: context.headlineSmallStyle?.copyWith(
                            color: AppColors.primaryWhite,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          handleControllers:
                              authController.setVerificationOtpControllers,
                          onSubmit: (_) => authController.submitVerification(
                            email: email,
                            onSuccess: onVerify,
                          ),
                        ),
                        24.ph,
                        GestureDetector(
                          onTap: () => authController.resendOtp(
                            email: email,
                            onResend: onResend,
                          ),
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                text: AppStrings.resendCodeIn,
                                style: context.bodySmallStyle?.copyWith(
                                  color: AppColors.hintGray,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text: authController.secondsUntilResend > 0
                                        ? '${authController.secondsUntilResend}s'
                                        : AppStrings.resendCode,
                                    style: context.bodySmallStyle?.copyWith(
                                      color: AppColors.primaryWhite,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        56.ph,
                        SignInPrimaryButton(
                          text: AppStrings.verifyCode,
                          onTap: () => authController.submitVerification(
                            email: email,
                            onSuccess: onVerify,
                          ),
                          isLoading: authController.isVerifying,
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
