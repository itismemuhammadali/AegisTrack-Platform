import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_scaffold.dart';
import '../../domain/entities/tracker_profile_row_entity.dart';
import '../controller/tracker_profile_controller.dart';
import '../widgets/tracker_contact_settings_widgets.dart';
import '../widgets/tracker_security_settings_widgets.dart';

/// Which notifications the viewer receives, reached from the profile's
/// Notification Settings row.
class TrackerNotificationSettingsView extends ConsumerWidget {
  const TrackerNotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerProfileControllerProvider);

    return TrackerDetailScaffold(
      title: AppStrings.trackerNotifSettingsTitle,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerNotifBackTooltip,
      child: ListView(
        key: const PageStorageKey('tracker-notification-settings'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          _section(
            AppStrings.trackerNotifChannels,
            controller.notificationChannels,
          ),
          24.ph,
          _section(AppStrings.trackerNotifAlertStyle, controller.alertStyle),
          24.ph,
          _section(
            AppStrings.trackerNotifTypes,
            controller.notificationTypes,
          ),
        ],
      ),
    );
  }

  Widget _section(
    String title,
    List<TrackerNotificationToggleEntity> toggles,
  ) =>
      TrackerSecuritySection(
        title: title,
        children: [
          for (final toggle in toggles)
            TrackerPreferenceRow(
              icon: toggle.icon,
              emoji: toggle.emoji,
              title: toggle.title,
              note: toggle.note,
              value: toggle.value,
              onToggle: toggle.onToggle,
              // This screen's switches keep the neutral track in both states.
              tinted: false,
              last: toggle == toggles.last,
            ),
        ],
      );
}
