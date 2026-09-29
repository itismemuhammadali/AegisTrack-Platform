import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_scaffold.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../controller/tracker_profile_controller.dart';
import '../widgets/tracker_contact_settings_widgets.dart';
import '../widgets/tracker_edit_profile_widgets.dart';

/// The viewer's phone number and its SMS preferences, reached from the
/// profile's Phone Number row.
class TrackerPhoneNumberView extends ConsumerWidget {
  const TrackerPhoneNumberView({super.key, this.onSendCode});

  final VoidCallback? onSendCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerProfileControllerProvider);

    return TrackerDetailScaffold(
      title: AppStrings.trackerPhoneTitle,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerPhoneBackTooltip,
      child: ListView(
        key: const PageStorageKey('tracker-phone-number'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          TrackerContactCard(
            icon: AppAssetsSvg.trackerPhoneSettingsPhone,
            title: AppStrings.trackerPhoneCurrent,
            value: controller.phone,
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
                const TrackerDetailText(AppStrings.trackerPhoneChangeTitle,
                    size: 20,
                    weight: FontWeight.w600,
                    height: 30 / 20,
                    color: AppColors.primaryWhite),
                16.ph,
                TrackerEditProfileField(
                  label: AppStrings.trackerPhoneNewLabel,
                  controller: controller.newPhoneController,
                  hint: AppStrings.trackerPhoneNewHint,
                  hintColor: AppColors.trackerPhoneHint,
                  keyboardType: TextInputType.phone,
                ),
                16.ph,
                GestureDetector(
                  onTap: onSendCode,
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
                        AppStrings.trackerPhoneSendCode,
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
                      AppStrings.trackerSmsPreferences,
                      size: 20,
                      weight: FontWeight.w600,
                      height: 30 / 20,
                      color: AppColors.primaryWhite),
                ),
                TrackerPreferenceRow(
                  title: AppStrings.trackerSmsNotifications,
                  note: AppStrings.trackerSmsNotificationsNote,
                  value: controller.smsNotifications,
                  onToggle: controller.toggleSmsNotifications,
                ),
                TrackerPreferenceRow(
                  icon: AppAssetsSvg.trackerShareEncryption,
                  title: AppStrings.trackerSmsTwoFactor,
                  note: AppStrings.trackerSmsTwoFactorNote,
                  value: controller.smsTwoFactor,
                  onToggle: controller.toggleSmsTwoFactor,
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
