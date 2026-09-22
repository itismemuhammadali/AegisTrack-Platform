import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_scaffold.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../controller/tracker_profile_controller.dart';
import '../widgets/tracker_edit_profile_widgets.dart';
import '../widgets/tracker_email_settings_widgets.dart';

/// The viewer's email address and what it receives, reached from the
/// profile's Email Settings row.
class TrackerEmailSettingsView extends ConsumerWidget {
  const TrackerEmailSettingsView({super.key, this.onUpdateEmail});

  final VoidCallback? onUpdateEmail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerProfileControllerProvider);

    return TrackerDetailScaffold(
      title: AppStrings.trackerEmailSettingsTitle,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerEmailSettingsBackTooltip,
      child: ListView(
        key: const PageStorageKey('tracker-email-settings'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          TrackerCurrentEmailCard(email: controller.email),
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
                const TrackerDetailText(AppStrings.trackerEmailChangeTitle,
                    size: 20,
                    weight: FontWeight.w600,
                    height: 30 / 20,
                    color: AppColors.primaryWhite),
                16.ph,
                TrackerEditProfileField(
                  label: AppStrings.trackerEmailNewLabel,
                  controller: controller.newEmailController,
                  hint: AppStrings.trackerEmailNewHint,
                  keyboardType: TextInputType.emailAddress,
                  filled: true,
                ),
                10.ph,
                TrackerEditProfileField(
                  label: AppStrings.trackerEmailConfirmPasswordLabel,
                  controller: controller.confirmPasswordController,
                  hint: AppStrings.trackerEmailConfirmPasswordHint,
                  obscure: true,
                  filled: true,
                ),
                16.ph,
                GestureDetector(
                  onTap: onUpdateEmail,
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
                        AppStrings.trackerEmailUpdate,
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
          Container(
            decoration: BoxDecoration(
              color: AppColors.trackerSurfaceFill,
              borderRadius: 16.circular,
              border: Border.all(color: AppColors.trackerSurfaceFill),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: AppInsets.all(20),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: AppColors.trackerSurfaceFill)),
                  ),
                  child: const TrackerDetailText(
                      AppStrings.trackerEmailPreferences,
                      size: 20,
                      weight: FontWeight.w600,
                      height: 30 / 20,
                      color: AppColors.primaryWhite),
                ),
                TrackerEmailPreferenceRow(
                  title: AppStrings.trackerEmailPrefNotifications,
                  note: AppStrings.trackerEmailPrefNotificationsNote,
                  value: controller.emailNotifications,
                  onToggle: controller.toggleEmailNotifications,
                ),
                TrackerEmailPreferenceRow(
                  title: AppStrings.trackerEmailPrefWeekly,
                  note: AppStrings.trackerEmailPrefWeeklyNote,
                  value: controller.weeklyReports,
                  onToggle: controller.toggleWeeklyReports,
                ),
                TrackerEmailPreferenceRow(
                  title: AppStrings.trackerEmailPrefSecurity,
                  note: AppStrings.trackerEmailPrefSecurityNote,
                  value: controller.securityAlerts,
                  onToggle: controller.toggleSecurityAlerts,
                  last: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
