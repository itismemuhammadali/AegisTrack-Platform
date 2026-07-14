import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../../../../core/utils/app_exports.dart';
import '../../../../onboarding/presentation/widgets/onboarding_page_scaffold.dart';
import '../controller/auth_controller.dart';
import '../widgets/sign_in_primary_button.dart';
import '../widgets/trust_device_toggle.dart';

class TwoFactorView extends HookConsumerWidget {
  const TwoFactorView({super.key, this.onVerify});

  final void Function(String code)? onVerify;

  static const _codeLength = 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);
    final trustDevice = useState(false);
    final otpControllers = useRef<List<TextEditingController?>>([]);

    final fieldFillColor = AppColors.primaryWhite.withValues(alpha: 0.05);
    final fieldBorderColor = AppColors.primaryWhite.withValues(alpha: 0.1);
    const focusedFieldBorderColor = AppColors.authFocusedFieldBorder;

    void submit() {
      final code = otpControllers.value
          .map((controller) => controller?.text ?? '')
          .join();
      authController.verifyTwoFactorCode(
        code: code,
        trustDevice: trustDevice.value,
        onSuccess: () => onVerify?.call(code),
      );
    }

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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 80.w,
                              height: 80.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.twoFactorAccentPurple
                                    .withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.twoFactorAccentPurple
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: SvgPicture.asset(
                                AppAssetsSvg.twoFactorShieldIcon,
                                width: 40.w,
                                height: 40.w,
                              ),
                            ),
                            24.ph,
                            Text(
                              AppStrings.twoFactorTitle,
                              textAlign: TextAlign.center,
                              style: context.headlineMediumStyle?.copyWith(
                                color: AppColors.primaryWhite,
                                fontSize: 36.sp,
                                fontWeight: FontWeight.w600,
                                height: 40 / 36,
                              ),
                            ),
                            24.ph,
                            Text(
                              AppStrings.twoFactorSubtitle,
                              textAlign: TextAlign.center,
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
                          handleControllers: (controllers) =>
                              otpControllers.value = controllers,
                          onSubmit: (_) => submit(),
                        ),
                        24.ph,
                        Container(
                          padding: EdgeInsets.all(17.w),
                          decoration: BoxDecoration(
                            color: fieldFillColor,
                            borderRadius: 16.circular,
                            border: Border.all(color: fieldBorderColor),
                          ),
                          child: Row(
                            children: [
                              TrustDeviceToggle(
                                value: trustDevice.value,
                                onChanged: (value) => trustDevice.value = value,
                              ),
                              12.pw,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppAssetsSvg.twoFactorDeviceIcon,
                                          width: 16.w,
                                          height: 16.w,
                                        ),
                                        8.pw,
                                        Text(
                                          AppStrings.trustThisDevice,
                                          style:
                                              context.bodyMediumStyle?.copyWith(
                                            color: AppColors.primaryWhite,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            height: 20 / 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      AppStrings.trustThisDeviceSubtitle,
                                      style: context.bodySmallStyle?.copyWith(
                                        color: AppColors.hintGray,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        height: 16 / 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        24.ph,
                        SignInPrimaryButton(
                          text: AppStrings.verifyAndContinue,
                          onTap: submit,
                          isLoading: authController.isVerifyingTwoFactor,
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
