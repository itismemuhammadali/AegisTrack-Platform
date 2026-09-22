import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_timeline_log_entity.dart';

/// Read-only log history. Figma sample records; replace with the viewer
/// timeline API.
class TrackerTimelineController extends ChangeNotifier with Buffers {
  static const List<String> filters = [
    AppStrings.trackerFilterAll,
    AppStrings.trackerFilterSecurityFlags,
    AppStrings.trackerFilterMissing,
    AppStrings.trackerOffline,
    AppStrings.trackerFilterZoneEvents,
    AppStrings.trackerFilterCheckIns,
    AppStrings.trackerLogSos,
  ];

  final String totalLogs = '248';
  final String verifiedLogs = '235';
  final String flaggedLogs = '3';

  static const _photoTag = TrackerTimelineTagEntity(
    label: AppStrings.trackerLogPhoto,
    color: AppColors.primaryWhite,
    icon: AppAssetsSvg.trackerTimelinePhoto,
  );
  static const _noteTag = TrackerTimelineTagEntity(
    label: AppStrings.trackerLogNote,
    color: AppColors.primaryWhite,
    icon: AppAssetsSvg.trackerTimelineNote,
  );

  final List<TrackerTimelineGroupEntity> groups = const [
    TrackerTimelineGroupEntity(
      title: AppStrings.trackerTimelineToday,
      logs: [
        TrackerTimelineLogEntity(
          name: 'Daniel Chen',
          kind: TrackerTimelineLogKind.checkIn,
          time: '14:32',
          location: '1251 Sixth Ave, New York, NY',
          authenticity: TrackerTimelineAuthenticityEntity.verified('94'),
          tags: [_photoTag, _noteTag],
        ),
        TrackerTimelineLogEntity(
          name: 'Sarah Martinez',
          kind: TrackerTimelineLogKind.zoneEvent,
          time: '14:18',
          location: 'Brooklyn Bridge, New York, NY',
          status: TrackerTimelineTagEntity(
            label: AppStrings.trackerLogEnteredZone,
            color: AppColors.trackerOrange,
          ),
          authenticity: TrackerTimelineAuthenticityEntity.acceptable('87'),
        ),
        TrackerTimelineLogEntity(
          name: 'Daniel Chen',
          kind: TrackerTimelineLogKind.missing,
          time: '12:00–13:30',
          location: '',
          status: TrackerTimelineTagEntity(
            label: AppStrings.trackerLogMissingPeriod,
            color: AppColors.trackerAmber,
            icon: AppAssetsSvg.trackerTimelineWarning,
          ),
          tags: [
            TrackerTimelineTagEntity(
              label: AppStrings.trackerLogSyncFailed,
              color: AppColors.trackerFlaggedRed,
              icon: AppAssetsSvg.trackerTimelineSyncFailed,
            ),
          ],
        ),
        TrackerTimelineLogEntity(
          name: 'Carlos Rivera',
          kind: TrackerTimelineLogKind.securityFlag,
          time: '11:45',
          location: 'Queens, New York, NY',
          status: TrackerTimelineTagEntity(
            label: AppStrings.trackerLogVpnDetected,
            color: AppColors.trackerFlaggedRed,
            icon: AppAssetsSvg.trackerTimelineVpn,
          ),
          authenticity: TrackerTimelineAuthenticityEntity.acceptable('88'),
          tags: [_noteTag],
        ),
        TrackerTimelineLogEntity(
          name: 'James Wilson',
          kind: TrackerTimelineLogKind.location,
          time: '09:15',
          location: 'Downtown Los Angeles, CA',
          isOffline: true,
          timeTag: TrackerTimelineTagEntity(
            label: AppStrings.trackerLogOffline,
            color: AppColors.trackerAmber,
            icon: AppAssetsSvg.trackerTimelineOffline,
          ),
          authenticity: TrackerTimelineAuthenticityEntity.acceptable('72'),
          tags: [
            _photoTag,
            TrackerTimelineTagEntity(
              label: AppStrings.trackerLogPending,
              color: AppColors.trackerAcceptableText,
              icon: AppAssetsSvg.trackerTimelinePending,
            ),
          ],
        ),
      ],
    ),
    TrackerTimelineGroupEntity(
      title: AppStrings.trackerTimelineYesterday,
      logs: [
        TrackerTimelineLogEntity(
          name: 'Lisa Park',
          kind: TrackerTimelineLogKind.sos,
          time: '08:30',
          location: 'Financial District, New York, NY',
          authenticity: TrackerTimelineAuthenticityEntity.verified('93'),
        ),
      ],
    ),
  ];

  String query = '';
  String filter = AppStrings.trackerFilterAll;

  /// Groups with their logs narrowed by the search box and filter chips;
  /// groups left without logs are dropped.
  List<TrackerTimelineGroupEntity> get visibleGroups => groups
      .map((group) => TrackerTimelineGroupEntity(
            title: group.title,
            logs: group.logs.where(_matches).toList(),
          ))
      .where((group) => group.logs.isNotEmpty)
      .toList();

  bool get isEmpty => visibleGroups.isEmpty;

  bool _matches(TrackerTimelineLogEntity log) {
    final matchesQuery =
        '${log.name} ${log.location}'.toLowerCase().contains(query);
    final matchesFilter = filter == AppStrings.trackerFilterAll ||
        (filter == AppStrings.trackerOffline
            ? log.isOffline
            : log.kind.filter == filter);
    return matchesQuery && matchesFilter;
  }

  void setQuery(String value) {
    query = value.trim().toLowerCase();
    notifyListeners();
  }

  void setFilter(String value) {
    filter = value;
    notifyListeners();
  }
}

final trackerTimelineControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackerTimelineController>(
  (ref) => TrackerTimelineController(),
);
