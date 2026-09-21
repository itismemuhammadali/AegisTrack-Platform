import '../../../../../components/custom_textfield.dart';
import '../../../../../core/utils/app_exports.dart';
import '../../../../onboarding/presentation/widgets/onboarding_page_scaffold.dart';
import '../controller/viewer_auth_controller.dart';

class ViewerForgotPasswordView extends ConsumerWidget {
  const ViewerForgotPasswordView({super.key, this.onContinue});

  final void Function(String email)? onContinue;

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
              key: controller.forgotPasswordFormKey,
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
                    child: Text(
                      AppStrings.forgetPasswordTitle,
                      style: context.headlineMediumStyle?.copyWith(
                        color: AppColors.primaryWhite,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        height: 40 / 32,
                      ),
                    ),
                  ),
                  24.ph,
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: controller.forgotEmailController,
                            hintText: AppStrings.email,
                            textInputType: TextInputType.emailAddress,
                            isLast: true,
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
                            onFieldSubmitted: (_) =>
                                controller.submitForgotPassword(
                              onSuccess: onContinue,
                            ),
                          ),
                          24.ph,
                          PrimaryAppButton(
                            text: AppStrings.continueAction,
                            isLoading: controller.isSendingReset,
                            onTap: () => controller.submitForgotPassword(
                              onSuccess: onContinue,
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
