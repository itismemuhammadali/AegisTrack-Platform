import '../../../../../core/utils/app_exports.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';
import '../controller/tracker_user_details_controller.dart';
import '../widgets/tracker_authenticity_card.dart';
import '../widgets/tracker_detail_button.dart';
import '../widgets/tracker_detail_scaffold.dart';
import '../widgets/tracker_detail_text.dart';
import '../widgets/tracker_quick_actions_grid.dart';
import '../widgets/tracker_recent_activity_card.dart';
import '../widgets/tracker_security_flags_card.dart';
import '../widgets/tracker_user_info_tile.dart';
import '../widgets/tracker_user_profile_card.dart';
import '../widgets/tracker_zone_events_card.dart';

/// Read-only overview of an assigned user.
class TrackerUserDetailsView extends ConsumerWidget {
  const TrackerUserDetailsView({
    super.key,
    required this.user,
    this.onAction,
    this.onSecurityDetails,
  });

  final TrackerUserEntity user;
  final VoidCallback? onSecurityDetails;
  final ValueChanged<String>? onAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerUserDetailsControllerProvider);

    return TrackerDetailScaffold(
      title: user.name,
      subtitle: AppStrings.trackerUserOverview,
      backTooltip: AppStrings.trackerBackToUsers,
      child: ListView(
        key: const PageStorageKey('tracker-user-details'),
        padding: AppInsets.only(left: 24, right: 24, top: 24, bottom: 24),
        children: [
          TrackerUserProfileCard(user: user, controller: controller),
          24.ph,
          TrackerUserInfoGrid(tiles: controller.infoTiles(user)),
          24.ph,
          TrackerAuthenticityCard(onSecurityDetails: onSecurityDetails),
          24.ph,
          const TrackerDetailText(AppStrings.trackerQuickActions,
              weight: FontWeight.w600),
          10.ph,
          TrackerQuickActionsGrid(
              actions: controller.quickActions, onAction: onAction),
          24.ph,
          const TrackerDetailText(AppStrings.trackerRecentActivity,
              weight: FontWeight.w600),
          10.ph,
          TrackerRecentActivityCard(activity: controller.recentActivity(user)),
          24.ph,
          const TrackerSecurityFlagsCard(),
          24.ph,
          TrackerZoneEventsCard(events: controller.zoneEventsToday),
          24.ph,
          Row(
            children: [
              Expanded(
                child: TrackerDetailButton(
                  AppStrings.trackerGenerateReport,
                  icon: AppAssetsSvg.trackerUserDetailReport,
                  onTap: onAction == null
                      ? null
                      : () => onAction!(AppStrings.trackerGenerateReport),
                ),
              ),
              24.pw,
              Expanded(
                child: TrackerDetailButton(
                  AppStrings.trackerSecureShare,
                  icon: AppAssetsSvg.trackerUserDetailShare,
                  primary: true,
                  onTap: onAction == null
                      ? null
                      : () => onAction!(AppStrings.trackerSecureShare),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
