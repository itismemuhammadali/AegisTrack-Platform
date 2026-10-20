import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_scaffold.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../controller/tracker_profile_controller.dart';
import '../widgets/tracker_contact_settings_widgets.dart';
import '../widgets/tracker_edit_profile_widgets.dart';
import '../widgets/tracker_security_settings_widgets.dart';

/// Account security, reached from both the profile's Security Settings and
/// Two-Factor Auth rows.
class TrackerSecuritySettingsView extends ConsumerWidget {
  const TrackerSecuritySettingsView({
    super.key,
    this.onUpdatePassword,
    this.onRevokeSession,
  });

  final VoidCallback? onUpdatePassword;
  final VoidCallback? onRevokeSession;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerProfileControllerProvider);
    final sessions = controller.sessions;

    return TrackerDetailScaffold(
      title: AppStrings.trackerSecuritySettingsTitle,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerSecurityBackTooltip,
      child: ListView(
        key: const PageStorageKey('tracker-security-settings'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          const TrackerSecurityStatusCard(),
          24.ph,
          TrackerSecuritySection(
            title: AppStrings.trackerSecurityAuthentication,
            children: [
              TrackerPreferenceRow(
                icon: AppAssetsSvg.trackerSecurityTwoFactor,
                title: AppStrings.trackerSecurityTwoFactorTitle,
                note: AppStrings.trackerSecurityTwoFactorNote,
                value: controller.twoFactorAuth,
                onToggle: controller.toggleTwoFactorAuth,
              ),
              TrackerPreferenceRow(
                icon: AppAssetsSvg.trackerSecurityBiometric,
                title: AppStrings.trackerSecurityBiometricTitle,
                note: AppStrings.trackerSecurityBiometricNote,
                value: controller.biometricLogin,
                onToggle: controller.toggleBiometricLogin,
                last: true,
              ),
            ],
          ),
          24.ph,
          Container(
            padding: AppInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.trackerSurfaceFill,
              borderRadius: 16.circular,
              border: Border.all(color: AppColors.trackerSurfaceFill),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(AppAssetsSvg.trackerSecurityPasswordLock,
                        width: 20.w, height: 20.w),
                    12.pw,
                    const Expanded(
                      child: TrackerDetailText(
                          AppStrings.trackerSecurityChangePassword,
                          size: 20,
                          weight: FontWeight.w600,
                          height: 30 / 20,
                          color: AppColors.primaryWhite),
                    ),
                  ],
                ),
                16.ph,
                TrackerEditProfileField(
                  label: AppStrings.trackerSecurityCurrentPassword,
                  controller: controller.currentPasswordController,
                  obscure: true,
                  filled: true,
                  showVisibilityToggle: true,
                ),
                10.ph,
                TrackerEditProfileField(
                  label: AppStrings.trackerSecurityNewPassword,
                  controller: controller.newPasswordController,
                  obscure: true,
                  filled: true,
                  showVisibilityToggle: true,
                ),
                10.ph,
                TrackerEditProfileField(
                  label: AppStrings.trackerSecurityConfirmPassword,
                  controller: controller.confirmNewPasswordController,
                  obscure: true,
                  filled: true,
                  showVisibilityToggle: true,
                ),
                16.ph,
                GestureDetector(
                  onTap: onUpdatePassword ??
                      () => controller.saveSecurity(
                            onSaved: () => Navigator.of(context).pop(),
                          ),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: AppInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.trackerPurpleDeep,
                      borderRadius: 20.circular,
                    ),
                    child: const TrackerDetailText(
                        AppStrings.trackerSecurityUpdatePassword,
                        size: 16,
                        weight: FontWeight.w500,
                        height: 24 / 16,
                        color: AppColors.primaryWhite),
                  ),
                ),
              ],
            ),
          ),
          24.ph,
          TrackerSecuritySection(
            title: AppStrings.trackerSecuritySessions,
            children: [
              for (final session in sessions)
                TrackerSessionRow(
                  session: session,
                  onRevoke: () {
                    if (onRevokeSession != null) {
                      onRevokeSession!();
                    } else {
                      controller.revokeSession(session);
                    }
                  },
                  last: session == sessions.last,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
