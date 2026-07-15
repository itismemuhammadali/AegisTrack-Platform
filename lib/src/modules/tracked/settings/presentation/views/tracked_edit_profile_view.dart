import '../../../../../components/image_source_sheet.dart';
import '../../../../../core/utils/app_exports.dart';
import '../controller/tracked_settings_controller.dart';
import '../widgets/tracked_edit_profile_action_bar.dart';
import '../widgets/tracked_edit_profile_avatar.dart';
import '../widgets/tracked_edit_profile_field.dart';
import '../widgets/tracked_edit_profile_header.dart';

class TrackedEditProfileView extends ConsumerWidget {
  const TrackedEditProfileView({super.key, this.onSaved});

  final VoidCallback? onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedSettingsControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.trackedLogCaptureHeaderBackdrop,
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 0.5, 1],
                colors: [
                  AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
                  AppColors.onboardingScrimNavy.withValues(alpha: 0.9),
                  AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            bottom: false,
            child: Column(
              children: [
                const TrackedEditProfileHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppInsets.only(left: 24, right: 24, bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TrackedEditProfileAvatar(
                          photo: controller.avatarPhoto,
                          onTap: () => ImageSourceSheet.show(
                            context,
                            isDark: true,
                            onPicked: controller.setAvatarPhoto,
                          ),
                        ),
                        24.ph,
                        TrackedEditProfileField(
                          label: AppStrings.trackedEditProfileFullNameLabel,
                          controller: controller.nameController,
                          icon: Icons.person_outline,
                          keyboardType: TextInputType.name,
                        ),
                        20.ph,
                        TrackedEditProfileField(
                          label: AppStrings.trackedEditProfileEmailLabel,
                          controller: controller.emailController,
                          svgIcon: AppAssetsSvg.signInEmailIcon,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        20.ph,
                        TrackedEditProfileField(
                          label: AppStrings.trackedEditProfilePhoneLabel,
                          controller: controller.phoneController,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ),
                TrackedEditProfileActionBar(
                  isSaving: controller.isSavingProfile,
                  onSave: () => controller.saveProfile(
                    onSaved: onSaved ?? AppRouterGo.back,
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
