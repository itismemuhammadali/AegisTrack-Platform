import 'dart:async';

import '../../../../../components/custom_textfield.dart';
import '../../../../../core/utils/app_exports.dart';
import '../../../../onboarding/presentation/widgets/onboarding_page_scaffold.dart';
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
  static const _resendSeconds = 58;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllers = useMemoized(
      () => List.generate(_codeLength, (_) => TextEditingController()),
    );
    final focusNodes = useMemoized(
      () => List.generate(_codeLength, (_) => FocusNode()),
    );
    final secondsLeft = useState(_resendSeconds);

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (secondsLeft.value <= 1) {
          timer.cancel();
          secondsLeft.value = 0;
        } else {
          secondsLeft.value -= 1;
        }
      });
      return timer.cancel;
    }, const []);

    useEffect(() {
      return () {
        for (final controller in controllers) {
          controller.dispose();
        }
        for (final focusNode in focusNodes) {
          focusNode.dispose();
        }
      };
    }, const []);

    final fieldFillColor = AppColors.primaryWhite.withValues(alpha: 0.05);
    final fieldBorderColor = AppColors.primaryWhite.withValues(alpha: 0.1);
    final focusedFieldBorderColor = const Color(
      0xFF70699F,
    ).withValues(alpha: 0.25);

    void onDigitChanged(int index, String value) {
      if (value.isNotEmpty && index < _codeLength - 1) {
        focusNodes[index + 1].requestFocus();
      } else if (value.isEmpty && index > 0) {
        focusNodes[index - 1].requestFocus();
      }
      if (controllers.every((controller) => controller.text.isNotEmpty)) {
        FocusScope.of(context).unfocus();
      }
    }

    void submit() {
      final code = controllers.map((controller) => controller.text).join();
      onVerify?.call(code);
    }

    void resend() {
      if (secondsLeft.value != 0) return;
      secondsLeft.value = _resendSeconds;
      onResend?.call();
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(_codeLength, (index) {
                            return SizedBox(
                              width: 48.w,
                              height: 56.h,
                              child: CustomTextField(
                                controller: controllers[index],
                                focusNode: focusNodes[index],
                                textInputType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                fieldBorderRadius: 16,
                                borderWidth: 1.085,
                                contentPadding: EdgeInsets.zero,
                                fillColor: fieldFillColor,
                                enableBorderColor: fieldBorderColor,
                                focusedBorderColor: focusedFieldBorderColor,
                                isLast: index == _codeLength - 1,
                                textStyle: context.headlineSmallStyle
                                    ?.copyWith(
                                      color: AppColors.primaryWhite,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                onChanged: (value) =>
                                    onDigitChanged(index, value),
                                onFieldSubmitted: (_) => submit(),
                              ),
                            );
                          }),
                        ),
                        24.ph,
                        GestureDetector(
                          onTap: resend,
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
                                    text: secondsLeft.value > 0
                                        ? '${secondsLeft.value}s'
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
                          onTap: submit,
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
