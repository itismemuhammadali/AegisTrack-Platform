import '../../../../../core/utils/app_exports.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';
import '../controller/tracker_users_controller.dart';
import '../widgets/tracker_detail_scaffold.dart';
import '../widgets/tracker_live_footer.dart';
import '../widgets/tracker_live_location_card.dart';
import '../widgets/tracker_live_map.dart';
import '../widgets/tracker_live_pings_card.dart';
import '../widgets/tracker_live_stat_card.dart';
import '../widgets/tracker_live_user_card.dart';

/// Read-only live position reached from a user's Live View quick action.
class TrackerLiveTrackingView extends ConsumerWidget {
  const TrackerLiveTrackingView({super.key, this.user});

  final TrackerUserEntity? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerUsersControllerProvider);
    final isOnline = controller.isLiveOnline;

    return TrackerDetailScaffold(
      title: AppStrings.trackerLiveTracking,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerBackToUserDetails,
      trailing: GestureDetector(
        onTap: controller.toggleLiveConnection,
        child: Container(
          padding: AppInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.trackerSurfaceFill,
            borderRadius: 16.circular,
            border: Border.all(color: AppColors.trackerBorderSoft),
          ),
          child: Text(
            isOnline
                ? AppStrings.trackerSimulateOffline
                : AppStrings.trackerSimulateOnline,
            style: context.bodySmallStyle?.copyWith(
              fontSize: 12.sp,
              height: 16 / 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryWhite,
            ),
          ),
        ),
      ),
      child: ListView(
        key: const PageStorageKey('tracker-live-tracking'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          TrackerLiveUserCard(
            name: user?.name ?? AppStrings.trackerMonitoredUser,
            initials: user == null ? '' : controller.initials(user!),
            isOnline: isOnline,
          ),
          24.ph,
          TrackerLiveMap(isOnline: isOnline),
          24.ph,
          TrackerLiveLocationCard(
            location: controller.liveLocation,
            coordinates: controller.liveCoordinates,
            updated: controller.liveUpdated,
            isOnline: isOnline,
          ),
          24.ph,
          TrackerLiveStatsRow(stats: controller.liveStats),
          24.ph,
          TrackerLivePingsCard(pings: controller.livePings),
          24.ph,
          TrackerLiveFooter(onRefresh: controller.refreshLive),
        ],
      ),
    );
  }
}
