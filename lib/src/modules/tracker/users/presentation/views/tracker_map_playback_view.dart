import '../../../../../core/utils/app_exports.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';
import '../../domain/entities/tracker_detail_info_entity.dart';
import '../../domain/entities/tracker_route_event_entity.dart';
import '../controller/tracker_users_controller.dart';
import '../widgets/tracker_detail_scaffold.dart';
import '../widgets/tracker_detail_text.dart';
import '../widgets/tracker_map_playback_controls.dart';
import '../widgets/tracker_map_playback_date_bar.dart';
import '../widgets/tracker_map_playback_filters.dart';
import '../widgets/tracker_map_playback_map.dart';
import '../widgets/tracker_map_playback_stats.dart';
import '../widgets/tracker_route_event_card.dart';

/// Read-only route playback reached from a user's Map Playback quick action.
class TrackerMapPlaybackView extends ConsumerWidget {
  const TrackerMapPlaybackView({
    super.key,
    this.user,
    this.onFilters,
    this.onViewLog,
  });

  final TrackerUserEntity? user;
  final VoidCallback? onFilters;
  final ValueChanged<TrackerRouteEventEntity>? onViewLog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerUsersControllerProvider);
    final title = user == null
        ? AppStrings.trackerMapPlayback
        : '${AppStrings.trackerMapPlayback} · ${user!.name}';

    return TrackerDetailScaffold(
      title: title,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerBackToTimeline,
      child: ListView(
        key: const PageStorageKey('tracker-map-playback'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          TrackerMapPlaybackDateBar(
            date: controller.playbackDate,
            range: controller.playbackRange,
            ranges: const [
              AppStrings.trackerRangeToday,
              AppStrings.trackerRangeCustom,
            ],
            onRangeSelected: controller.setPlaybackRange,
          ),
          24.ph,
          TrackerMapPlaybackMap(
            startTime: controller.playbackStartTime,
            endTime: controller.playbackEndTime,
            zoneEntryTime: controller.playbackZoneEntryTime,
            checkInTime: controller.playbackCheckInTime,
            missingWindow: controller.playbackMissingWindow,
          ),
          24.ph,
          TrackerMapPlaybackControls(
            startTime: controller.playbackStartTime,
            endTime: controller.playbackEndTime,
            currentTime: controller.playbackCurrentTime,
            progress: controller.playbackProgress,
            speeds: TrackerUsersController.playbackSpeeds,
            speed: controller.playbackSpeed,
            onSpeedSelected: controller.setPlaybackSpeed,
            onPlay: controller.togglePlayback,
          ),
          24.ph,
          TrackerMapPlaybackStats(
            stats: [
              TrackerDetailInfoEntity(
                  label: AppStrings.trackerStatDuration,
                  value: controller.playbackDuration),
              TrackerDetailInfoEntity(
                  label: AppStrings.trackerStatDistance,
                  value: controller.playbackDistance),
              TrackerDetailInfoEntity(
                  label: AppStrings.trackerStatPings,
                  value: controller.playbackPings),
              TrackerDetailInfoEntity(
                  label: AppStrings.trackerStatMissing,
                  value: controller.playbackMissing),
            ],
          ),
          24.ph,
          TrackerMapPlaybackFilters(onTap: onFilters),
          24.ph,
          const TrackerDetailText(AppStrings.trackerRouteTimeline,
              weight: FontWeight.w600, height: 20 / 14),
          8.ph,
          for (final event in controller.routeEvents) ...[
            TrackerRouteEventCard(
              event: event,
              onViewLog: onViewLog == null ? null : () => onViewLog!(event),
            ),
            8.ph,
          ],
        ],
      ),
    );
  }
}
