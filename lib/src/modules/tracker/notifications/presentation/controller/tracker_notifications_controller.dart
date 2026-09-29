import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_notification_entity.dart';

/// The viewer alert centre. Figma sample records; replace with the alerts API.
class TrackerNotificationsController extends ChangeNotifier with Buffers {
  static const List<String> filters = [
    AppStrings.trackerFilterAll,
    AppStrings.trackerFilterSos,
    AppStrings.trackerFilterRestrictedZone,
    AppStrings.trackerFilterMissedCheckIn,
    AppStrings.trackerFilterSecurity,
    AppStrings.trackerFilterMissingLogs,
  ];

  final List<TrackerNotificationGroupEntity> groups = const [
    TrackerNotificationGroupEntity(
      title: AppStrings.trackerTimelineToday,
      alerts: [
        TrackerNotificationEntity(
          kind: TrackerNotificationKind.sos,
          name: 'Lisa Park',
          detail: 'Financial District, NY',
          time: '30 sec ago',
          severity: TrackerNotificationSeverity.critical,
          isUnread: true,
        ),
        TrackerNotificationEntity(
          kind: TrackerNotificationKind.restrictedZone,
          name: 'Daniel Chen',
          detail: 'Restricted Area B',
          time: '2 hrs ago',
          severity: TrackerNotificationSeverity.high,
          isUnread: true,
        ),
        TrackerNotificationEntity(
          kind: TrackerNotificationKind.missedCheckIn,
          name: 'James Wilson',
          detail: 'Scheduled 14:30',
          time: '3 hrs ago',
          severity: TrackerNotificationSeverity.medium,
          isUnread: true,
        ),
        TrackerNotificationEntity(
          kind: TrackerNotificationKind.antiSpoofing,
          name: 'Carlos Rivera',
          detail: 'Mock Location Detected',
          time: '5 hrs ago',
          severity: TrackerNotificationSeverity.high,
        ),
      ],
    ),
    TrackerNotificationGroupEntity(
      title: AppStrings.trackerTimelineYesterday,
      alerts: [
        TrackerNotificationEntity(
          kind: TrackerNotificationKind.missingLog,
          name: 'James Wilson',
          detail: '90-min gap 10:00–11:30',
          time: AppStrings.trackerTimelineYesterday,
          severity: TrackerNotificationSeverity.medium,
        ),
        TrackerNotificationEntity(
          kind: TrackerNotificationKind.securityEvent,
          name: 'Aisha Johnson',
          detail: 'VPN Detected',
          time: AppStrings.trackerTimelineYesterday,
          severity: TrackerNotificationSeverity.low,
        ),
      ],
    ),
  ];

  String filter = AppStrings.trackerFilterAll;

  int get unreadCount => groups
      .expand((group) => group.alerts)
      .where((alert) => alert.isUnread)
      .length;

  /// Groups narrowed by the filter chips; empty groups are dropped.
  List<TrackerNotificationGroupEntity> get visibleGroups => groups
      .map((group) => TrackerNotificationGroupEntity(
            title: group.title,
            alerts: group.alerts
                .where((alert) =>
                    filter == AppStrings.trackerFilterAll ||
                    alert.kind.filter == filter)
                .toList(),
          ))
      .where((group) => group.alerts.isNotEmpty)
      .toList();

  void setFilter(String value) {
    filter = value;
    notifyListeners();
  }
}

final trackerNotificationsControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackerNotificationsController>(
  (ref) => TrackerNotificationsController(),
);
