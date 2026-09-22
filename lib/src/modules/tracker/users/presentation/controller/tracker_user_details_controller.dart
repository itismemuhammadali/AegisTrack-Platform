import '../../../../../core/utils/app_exports.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';
import '../../domain/entities/tracker_activity_entity.dart';
import '../../domain/entities/tracker_detail_info_entity.dart';
import '../../domain/entities/tracker_quick_action_entity.dart';
import '../../domain/entities/tracker_zone_event_entity.dart';

/// Read-only overview data. Metrics and history are the Figma sample data
/// until the assigned-user detail API is connected.
class TrackerUserDetailsController extends ChangeNotifier with Buffers {
  final String lastSync = '14:32 today';
  final String activeAlerts = '2';
  final String missedCheckIns = '1';
  final String zoneEvents = '3 today';
  final String securityFlags = '0';

  final List<TrackerQuickActionEntity> quickActions = const [
    TrackerQuickActionEntity(
      label: AppStrings.trackerActionTimeline,
      icon: AppAssetsSvg.trackerUserDetailTimeline,
    ),
    TrackerQuickActionEntity(
      label: AppStrings.trackerActionMapPlayback,
      icon: AppAssetsSvg.trackerUserDetailMap,
    ),
    TrackerQuickActionEntity(
      label: AppStrings.trackerActionLiveView,
      icon: AppAssetsSvg.trackerUserDetailLive,
    ),
    TrackerQuickActionEntity(
      label: AppStrings.trackerActionCheckIns,
      icon: AppAssetsSvg.trackerUserDetailCheckIns,
    ),
    TrackerQuickActionEntity(
      label: AppStrings.trackerActionAiInsights,
      icon: AppAssetsSvg.trackerUserDetailAi,
      badge: AppStrings.trackerBadgeExpert,
      badgeColor: AppColors.trackerExpertBadge,
    ),
    TrackerQuickActionEntity(
      label: AppStrings.trackerActionViewAlerts,
      icon: AppAssetsSvg.trackerUserDetailAlerts,
      badge: '2',
      badgeColor: AppColors.trackerDangerRed,
    ),
  ];

  final List<TrackerZoneEventEntity> zoneEventsToday = const [
    TrackerZoneEventEntity(
      time: '09:15',
      title: AppStrings.trackerZoneEntered,
      place: AppStrings.trackerZonePlace,
    ),
    TrackerZoneEventEntity(
      time: '17:30',
      title: AppStrings.trackerZoneExited,
      place: AppStrings.trackerZonePlace,
    ),
  ];

  String statusLabel(TrackerUserEntity user) => user.isSos
      ? AppStrings.trackerSos
      : user.isOnline
          ? AppStrings.trackerOnline
          : AppStrings.trackerOffline;

  Color statusColor(TrackerUserEntity user) => user.isSos
      ? AppColors.trackerSosRed
      : user.isOnline
          ? AppColors.trackerOnlineGreen
          : AppColors.trackerMutedText;

  String initials(TrackerUserEntity user) => user.name
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0])
      .join();

  String lastLocation(TrackerUserEntity user) =>
      user.location.replaceFirst('Last: ', '');

  List<TrackerDetailInfoEntity> infoTiles(TrackerUserEntity user) => [
        TrackerDetailInfoEntity(
            label: AppStrings.trackerLastLocation, value: lastLocation(user)),
        TrackerDetailInfoEntity(
          label: AppStrings.trackerLastLog,
          value: user.name == 'Daniel Chen'
              ? '2 min ago'
              : user.lastSeen.split('•').last.trim(),
        ),
        TrackerDetailInfoEntity(
            label: AppStrings.trackerLastSync, value: lastSync),
        TrackerDetailInfoEntity(
          label: AppStrings.trackerConnection,
          value: user.isOnline
              ? AppStrings.trackerOnline
              : AppStrings.trackerOffline,
        ),
        TrackerDetailInfoEntity(
            label: AppStrings.trackerActiveAlerts, value: activeAlerts),
        TrackerDetailInfoEntity(
            label: AppStrings.trackerMissedCheckIns, value: missedCheckIns),
        TrackerDetailInfoEntity(
            label: AppStrings.trackerZoneEvents, value: zoneEvents),
        TrackerDetailInfoEntity(
            label: AppStrings.trackerSecurityFlags, value: securityFlags),
        const TrackerDetailInfoEntity(
          label: AppStrings.trackerAuthenticityTrend,
          value: AppStrings.trackerAuthenticityTrendValue,
        ),
      ];

  List<TrackerActivityEntity> recentActivity(TrackerUserEntity user) => [
        TrackerActivityEntity(
          time: '14:32',
          label: AppStrings.trackerActivityCheckIn,
          location: lastLocation(user),
          color: AppColors.trackerOnlineGreen,
        ),
        const TrackerActivityEntity(
          time: '13:15',
          label: AppStrings.trackerActivityZoneEntry,
          location: AppStrings.trackerPermittedZone,
          color: AppColors.trackerInfoBlue,
        ),
        const TrackerActivityEntity(
          time: '09:10',
          label: AppStrings.trackerActivityStarted,
          location: AppStrings.trackerSessionBegun,
          color: AppColors.trackerMutedText,
        ),
      ];
}

final trackerUserDetailsControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackerUserDetailsController>(
  (ref) => TrackerUserDetailsController(),
);
