import '../../../../../core/utils/app_exports.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';
import '../../domain/entities/tracker_activity_entity.dart';
import '../controller/tracker_users_controller.dart';
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
    this.onActivitySelected,
  });

  final TrackerUserEntity user;
  final VoidCallback? onSecurityDetails;
  final ValueChanged<String>? onAction;

  /// Opens the log record behind a recent activity row.
  final ValueChanged<TrackerActivityEntity>? onActivitySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerUsersControllerProvider);

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
          TrackerAuthenticityCard(
            score: controller.authenticityScore(user),
            label: controller.authenticityLabel(user),
            note: controller.authenticityNote(user),
            color: controller.authenticityColor(user),
            badgeFill: controller.authenticityBadgeFill(user),
            onSecurityDetails: onSecurityDetails,
          ),
          24.ph,
          const TrackerDetailText(AppStrings.trackerQuickActions,
              weight: FontWeight.w600),
          10.ph,
          TrackerQuickActionsGrid(
              actions: controller.quickActions(user), onAction: onAction),
          24.ph,
          const TrackerDetailText(AppStrings.trackerRecentActivity,
              weight: FontWeight.w600),
          10.ph,
          TrackerRecentActivityCard(
            activity: controller.recentActivity(user),
            onEntrySelected: onActivitySelected,
          ),
          24.ph,
          TrackerSecurityFlagsCard(
            headline: controller.securityFlagHeadline(user),
            note: controller.securityFlagNote(user),
            flagged: user.hasSecurityFlags,
          ),
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
