import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/controller/tracker_dashboard_controller.dart';
import '../controller/tracker_profile_controller.dart';
import '../widgets/tracker_profile_access_note.dart';
import '../widgets/tracker_profile_header_card.dart';
import '../widgets/tracker_profile_logout_button.dart';
import '../widgets/tracker_profile_section.dart';

class TrackerProfileView extends ConsumerWidget {
  const TrackerProfileView({super.key, this.onAction, this.onLogout});

  final ValueChanged<String>? onAction;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerProfileControllerProvider);

    return ListView(
      key: const PageStorageKey('tracker-profile'),
      padding: AppInsets.only(left: 24, right: 24, top: 24) +
          EdgeInsets.only(bottom: 24.h + MediaQuery.paddingOf(context).bottom),
      children: [
        TrackerProfileHeaderCard(
          name: controller.name,
          email: controller.email,
          stats: controller.stats,
          onEdit: onAction == null
              ? null
              : () => onAction!(AppStrings.trackerEditProfile),
        ),
        24.ph,
        const TrackerProfileAccessNote(),
        24.ph,
        for (final section in controller.sections)
          TrackerProfileSection(
            section: section,
            onRowTap: (row) => row.opensAssignedUsers
                ? () =>
                    ref.read(trackerDashboardControllerProvider).onTabTapped(1)
                : onAction == null
                    ? null
                    : () => onAction!(row.label),
          ),
        TrackerProfileLogoutButton(onLogout: onLogout),
        24.ph,
        Text(
          AppStrings.trackerAppVersionFooter,
          textAlign: TextAlign.center,
          style: context.bodySmallStyle?.copyWith(
            fontSize: 12.sp,
            color: AppColors.trackerAlertSubtitle,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
