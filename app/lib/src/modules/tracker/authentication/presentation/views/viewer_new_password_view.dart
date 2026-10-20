import '../../../../../components/custom_textfield.dart';
import '../../../../../core/utils/app_exports.dart';
import '../../../../onboarding/presentation/widgets/onboarding_page_scaffold.dart';
import '../controller/viewer_auth_controller.dart';

class ViewerNewPasswordView extends ConsumerWidget {
  const ViewerNewPasswordView({super.key, this.onSaved});

  final VoidCallback? onSaved;

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
              key: controller.newPasswordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  24.ph,
                  Padding(
                    padding: AppInsets.symmetric(horizontal: 24),
                    child: Text(
                      AppStrings.newPasswordTitle,
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
                            controller: controller.newPasswordController,
                            hintText: AppStrings.password,
                            isObscure: controller.obscureNewPassword,
                            isPrefix: true,
                            prefixWidget: SvgPicture.asset(
                              AppAssetsSvg.signInPasswordIcon,
                              width: 20.sp,
                              height: 20.sp,
                            ),
                            suffixbutton: IconButton(
                              splashRadius: 20.r,
                              onPressed: controller.toggleNewPasswordVisibility,
                              icon: Icon(
                                controller.obscureNewPassword
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
                          24.ph,
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
                              controller.newPasswordController,
                            ),
                            onFieldSubmitted: (_) => controller
                                .submitNewPassword(onSuccess: onSaved),
                          ),
                          24.ph,
                          PrimaryAppButton(
                            text: AppStrings.continueAction,
                            isLoading: controller.isSavingPassword,
                            onTap: () => controller.submitNewPassword(
                              onSuccess: onSaved,
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
