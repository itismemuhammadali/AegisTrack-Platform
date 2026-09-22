import '../../../../../core/utils/app_exports.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';
import '../../domain/entities/tracker_activity_entity.dart';
import '../../domain/entities/tracker_check_in_entity.dart';
import '../../domain/entities/tracker_detail_info_entity.dart';
import '../../domain/entities/tracker_live_status_entity.dart';
import '../../domain/entities/tracker_log_detail_entity.dart';
import '../../domain/entities/tracker_device_info_entity.dart';
import '../../domain/entities/tracker_quick_action_entity.dart';
import '../../domain/entities/tracker_route_event_entity.dart';
import '../../domain/entities/tracker_security_check_entity.dart';
import '../../domain/entities/tracker_timeline_log_entity.dart';
import '../../domain/entities/tracker_zone_event_entity.dart';

/// Drives every read-only viewer users screen: the assigned users list, a
/// user's overview, their security report and their timeline.
///
/// All records are the Figma sample data; replace them with the viewer API.
class TrackerUsersController extends ChangeNotifier with Buffers {
  // ---------------------------------------------------------------- users

  static const List<String> userFilters = [
    AppStrings.trackerFilterAll,
    AppStrings.trackerOnline,
    AppStrings.trackerOffline,
    AppStrings.trackerSos,
    AppStrings.trackerFilterFlagged,
  ];

  final List<TrackerUserEntity> users = const [
    TrackerUserEntity(
      name: 'Daniel Chen',
      lastSeen: 'Today • 3 min ago',
      location: 'Midtown Manhattan, NY',
      authenticity: TrackerAuthenticity.acceptable,
    ),
    TrackerUserEntity(
      name: 'Aisha Johnson',
      lastSeen: 'Today • 2 min ago',
      location: 'Jersey City, NJ',
      authenticity: TrackerAuthenticity.verified,
    ),
    TrackerUserEntity(
      name: 'Sarah Martinez',
      lastSeen: 'Today • 2hrs ago',
      location: 'Last: Downtown LA',
      authenticity: TrackerAuthenticity.acceptable,
      isOnline: false,
    ),
    TrackerUserEntity(
      name: 'James Wilson',
      lastSeen: 'Today • 3 min ago',
      location: 'Central Park, NY',
      authenticity: TrackerAuthenticity.questionable,
      isOnline: false,
    ),
    TrackerUserEntity(
      name: 'Emma Davis',
      lastSeen: 'Today • 45 min ago',
      location: 'Queens, NY',
      authenticity: TrackerAuthenticity.verified,
      isOnline: false,
      isSos: true,
    ),
  ];

  String userQuery = '';
  String userFilter = AppStrings.trackerFilterAll;

  List<TrackerUserEntity> get visibleUsers => users.where((user) {
        final matchesQuery =
            '${user.name} ${user.location}'.toLowerCase().contains(userQuery);
        final matchesFilter = switch (userFilter) {
          AppStrings.trackerOnline => user.isOnline,
          AppStrings.trackerOffline => !user.isOnline && !user.isSos,
          AppStrings.trackerSos => user.isSos,
          AppStrings.trackerFilterFlagged =>
            user.authenticity == TrackerAuthenticity.questionable,
          _ => true,
        };
        return matchesQuery && matchesFilter;
      }).toList();

  void setUserQuery(String value) {
    userQuery = value.trim().toLowerCase();
    notifyListeners();
  }

  void setUserFilter(String value) {
    userFilter = value;
    notifyListeners();
  }

  // -------------------------------------------------------- user overview

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

  // --- Log detail ----------------------------------------------------------

  /// The bands are fixed scale documentation, not per-log data.
  static const List<TrackerLogScoreBandEntity> scoreBands = [
    TrackerLogScoreBandEntity(
      label: AppStrings.trackerLogBandVerified,
      range: AppStrings.trackerLogBandVerifiedRange,
      color: AppColors.trackerOnlineGreen,
      fill: AppColors.trackerOnlinePillFill,
      border: AppColors.trackerSuccessSurface,
    ),
    TrackerLogScoreBandEntity(
      label: AppStrings.trackerLogBandAcceptable,
      range: AppStrings.trackerLogBandAcceptableRange,
      color: AppColors.trackerAcceptableText,
      fill: AppColors.trackerLogAcceptableFill,
      border: AppColors.trackerLogAcceptableBorder,
    ),
    TrackerLogScoreBandEntity(
      label: AppStrings.trackerLogBandQuestionable,
      range: AppStrings.trackerLogBandQuestionableRange,
      color: AppColors.trackerOrange,
      fill: AppColors.trackerLogQuestionableFill,
      border: AppColors.trackerOrangeSurface,
    ),
    TrackerLogScoreBandEntity(
      label: AppStrings.trackerLogBandSuspect,
      range: AppStrings.trackerLogBandSuspectRange,
      color: AppColors.trackerFlaggedRed,
      fill: AppColors.trackerDangerPillFill,
      border: AppColors.trackerLogSuspectBorder,
    ),
  ];

  /// Figma sample record; replace with the viewer log API.
  final TrackerLogDetailEntity logDetail = const TrackerLogDetailEntity(
    sequence: '1',
    status: AppStrings.trackerLogArchived,
    kindLabel: AppStrings.trackerCaseTagCheckIn,
    kindColor: AppColors.trackerInfoBlue,
    kindFill: AppColors.trackerInfoBlueSurface,
    timestamp: 'Dec 12, 2024 · 14:32:07 UTC',
    score: '94',
    scoreColor: AppColors.trackerOnlineGreen,
    scoreNote: AppStrings.trackerLogScoreNote,
    gpsFields: [
      TrackerLogFieldEntity(
        label: AppStrings.trackerLogCoordinates,
        value: '40.7589° N, 73.9851° W',
        locked: true,
        monospace: true,
      ),
      TrackerLogFieldEntity(
        label: AppStrings.trackerLogAddress,
        value: '1251 Sixth Ave, New York, NY 10020',
        locked: true,
      ),
      TrackerLogFieldEntity(
        label: AppStrings.trackerLogAccuracy,
        value: '±4.2 meters',
        locked: true,
        monospace: true,
      ),
      TrackerLogFieldEntity(
        label: AppStrings.trackerLogAltitude,
        value: '22.4m',
        locked: true,
        monospace: true,
      ),
      TrackerLogFieldEntity(
        label: AppStrings.trackerLogGpsProvider,
        value: 'Device GPS',
        locked: true,
      ),
    ],
    syncFields: [
      TrackerLogFieldEntity(
        label: AppStrings.trackerLogSyncStatus,
        value: 'Synced',
        valueColor: AppColors.trackerOnlineGreen,
        leadingDot: true,
      ),
      TrackerLogFieldEntity(
        label: AppStrings.trackerLogSyncTime,
        value: 'Dec 12, 2024 · 14:32:09 UTC',
        monospace: true,
      ),
      TrackerLogFieldEntity(
        label: AppStrings.trackerLogDeviceLabel,
        value: 'iPhone 14 Pro',
        icon: AppAssetsSvg.trackerLogDevice,
      ),
      TrackerLogFieldEntity(
          label: AppStrings.trackerLogNetwork, value: 'Wi-Fi'),
      TrackerLogFieldEntity(
        label: AppStrings.trackerLogConnectionQuality,
        value: 'Strong',
        valueColor: AppColors.trackerOnlineGreen,
      ),
    ],
    eventFields: [
      TrackerLogFieldEntity(
          label: AppStrings.trackerLogZone,
          value: 'Permitted Zone – Office Building'),
      TrackerLogFieldEntity(
        label: AppStrings.trackerLogRelatedCheckIn,
        value: 'CHK-2024-441 "14:30 Scheduled"',
      ),
    ],
    notes: 'Arrived at office. All clear.',
    attachmentSummary: '1 photo attached',
    mediaCaption: 'Photo Evidence · 1 attachment',
  );

  // --- AI insights ---------------------------------------------------------

  static const List<String> aiDateRanges = [
    AppStrings.trackerAiRangeToday,
    AppStrings.trackerAiRangeLast7Days,
    AppStrings.trackerAiRangeLast30Days,
    AppStrings.trackerAiRangeCustom,
  ];

  String aiDateRange = AppStrings.trackerAiRangeLast7Days;

  void setAiDateRange(String range) {
    if (aiDateRange == range) return;
    aiDateRange = range;
    notifyListeners();
  }

  String initials(TrackerUserEntity user) => user.name
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0])
      .join();

  /// Recent activity keeps the designed sample location when the subject
  /// carries none of its own.
  static const String _fallbackActivityLocation = 'Midtown Manhattan, NY';

  String lastLocation(TrackerUserEntity user) => user.location.isEmpty
      ? _fallbackActivityLocation
      : user.location.replaceFirst('Last: ', '');

  /// An unidentified subject has no history behind it, so every metric reads
  /// Unknown / N/A instead of the tracked user's figures.
  List<TrackerDetailInfoEntity> infoTiles(TrackerUserEntity user) =>
      user.isIdentified
          ? [
              TrackerDetailInfoEntity(
                  label: AppStrings.trackerLastLocation,
                  value: lastLocation(user)),
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
                  label: AppStrings.trackerMissedCheckIns,
                  value: missedCheckIns),
              TrackerDetailInfoEntity(
                  label: AppStrings.trackerZoneEvents, value: zoneEvents),
              TrackerDetailInfoEntity(
                  label: AppStrings.trackerSecurityFlags, value: securityFlags),
              const TrackerDetailInfoEntity(
                label: AppStrings.trackerAuthenticityTrend,
                value: AppStrings.trackerAuthenticityTrendValue,
              ),
            ]
          : const [
              TrackerDetailInfoEntity(
                  label: AppStrings.trackerLastLocation,
                  value: AppStrings.trackerValueUnknown),
              TrackerDetailInfoEntity(
                  label: AppStrings.trackerLastLog,
                  value: AppStrings.trackerValueNotAvailable),
              TrackerDetailInfoEntity(
                  label: AppStrings.trackerLastSync,
                  value: AppStrings.trackerValueNotAvailable),
              TrackerDetailInfoEntity(
                  label: AppStrings.trackerConnection,
                  value: AppStrings.trackerValueUnknown),
              TrackerDetailInfoEntity(
                  label: AppStrings.trackerActiveAlerts,
                  value: AppStrings.trackerValueZero),
              TrackerDetailInfoEntity(
                  label: AppStrings.trackerMissedCheckIns,
                  value: AppStrings.trackerValueZero),
              TrackerDetailInfoEntity(
                  label: AppStrings.trackerZoneEvents,
                  value: AppStrings.trackerValueZoneEventsNone),
              TrackerDetailInfoEntity(
                  label: AppStrings.trackerSecurityFlags,
                  value: AppStrings.trackerValueZero),
              TrackerDetailInfoEntity(
                label: AppStrings.trackerAuthenticityTrend,
                value: AppStrings.trackerValueNotAvailable,
              ),
            ];

  // Authenticity block: verified for a tracked user, suspect for an
  // unidentified one.
  bool isSuspect(TrackerUserEntity user) =>
      !user.isIdentified || user.authenticity == TrackerAuthenticity.suspect;

  String authenticityScore(TrackerUserEntity user) => isSuspect(user)
      ? AppStrings.trackerScoreSuspectValue
      : AppStrings.trackerAuthenticityScoreValue;

  String authenticityLabel(TrackerUserEntity user) => isSuspect(user)
      ? AppStrings.trackerScoreSuspect
      : AppStrings.trackerVerified;

  String authenticityNote(TrackerUserEntity user) => isSuspect(user)
      ? AppStrings.trackerSuspectNote
      : AppStrings.trackerAuthenticityScoreNote;

  Color authenticityColor(TrackerUserEntity user) => isSuspect(user)
      ? AppColors.trackerSuspectRed
      : AppColors.trackerOnlineGreen;

  Color authenticityBadgeFill(TrackerUserEntity user) => isSuspect(user)
      ? AppColors.trackerSuspectFill
      : AppColors.trackerOnlineGreen.withValues(alpha: .1);

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

  // ------------------------------------------------------ security report

  final String securityScore = AppStrings.trackerAuthenticityScoreValue;

  /// Checks rendered above the VPN advisory notice.
  final List<TrackerSecurityCheckEntity> primaryChecks = const [
    TrackerSecurityCheckEntity(label: AppStrings.trackerCheckMockLocation),
    TrackerSecurityCheckEntity(label: AppStrings.trackerCheckFakeGps),
    TrackerSecurityCheckEntity(label: AppStrings.trackerCheckRoot),
    TrackerSecurityCheckEntity(label: AppStrings.trackerCheckAppIntegrity),
    TrackerSecurityCheckEntity(label: AppStrings.trackerCheckDeviceIntegrity),
    TrackerSecurityCheckEntity(
      label: AppStrings.trackerCheckVpn,
      status: AppStrings.trackerStatusFlagged,
      icon: AppAssetsSvg.trackerSecurityFlagged,
      color: AppColors.trackerFlaggedRed,
      background: AppColors.trackerDangerSurface,
      description: AppStrings.trackerVpnDetected,
    ),
  ];

  /// Checks rendered below the VPN advisory notice.
  final List<TrackerSecurityCheckEntity> secondaryChecks = const [
    TrackerSecurityCheckEntity(label: AppStrings.trackerCheckClock),
    TrackerSecurityCheckEntity(
      label: AppStrings.trackerCheckBluetooth,
      status: AppStrings.trackerStatusUnavailable,
      icon: AppAssetsSvg.trackerSecurityUnavailable,
      color: AppColors.primaryWhite,
      background: AppColors.trackerBorderSoft,
      description: AppStrings.trackerBluetoothDisabled,
    ),
    TrackerSecurityCheckEntity(
      label: AppStrings.trackerCheckSuspicious,
      status: AppStrings.trackerStatusUnderReview,
      icon: AppAssetsSvg.trackerSecurityReview,
      color: AppColors.trackerInfoBlue,
      background: AppColors.trackerInfoBlueSurface,
      description: AppStrings.trackerPatternAnalysis,
    ),
  ];

  final List<TrackerDeviceInfoEntity> deviceInfo = const [
    TrackerDeviceInfoEntity(
        label: AppStrings.trackerDeviceModel, value: 'iPhone 14 Pro'),
    TrackerDeviceInfoEntity(
        label: AppStrings.trackerDeviceOs, value: 'iOS 17.2.1'),
    TrackerDeviceInfoEntity(
        label: AppStrings.trackerAppVersionLabel, value: '3.4.2 (Build 441)'),
    TrackerDeviceInfoEntity(
        label: AppStrings.trackerDeviceId, value: '••••7f3a'),
  ];

  // ------------------------------------------------------------- timeline

  static const List<String> timelineFilters = [
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

  final List<TrackerTimelineGroupEntity> timelineGroups = const [
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

  String timelineQuery = '';
  String timelineFilter = AppStrings.trackerFilterAll;

  /// Groups with their logs narrowed by the search box and filter chips;
  /// groups left without logs are dropped.
  List<TrackerTimelineGroupEntity> get visibleTimelineGroups => timelineGroups
      .map((group) => TrackerTimelineGroupEntity(
            title: group.title,
            logs: group.logs.where(_matchesTimelineLog).toList(),
          ))
      .where((group) => group.logs.isNotEmpty)
      .toList();

  bool _matchesTimelineLog(TrackerTimelineLogEntity log) {
    final matchesQuery =
        '${log.name} ${log.location}'.toLowerCase().contains(timelineQuery);
    final matchesFilter = timelineFilter == AppStrings.trackerFilterAll ||
        (timelineFilter == AppStrings.trackerOffline
            ? log.isOffline
            : log.kind.filter == timelineFilter);
    return matchesQuery && matchesFilter;
  }

  void setTimelineQuery(String value) {
    timelineQuery = value.trim().toLowerCase();
    notifyListeners();
  }

  void setTimelineFilter(String value) {
    timelineFilter = value;
    notifyListeners();
  }

  // --------------------------------------------------------- map playback

  static const List<String> playbackSpeeds = [
    AppStrings.trackerSpeed1x,
    AppStrings.trackerSpeed2x,
    AppStrings.trackerSpeed4x,
  ];

  final String playbackDate = 'Dec 12, 2024';
  final String playbackStartTime = '09:15';
  final String playbackEndTime = '17:42';
  final String playbackCurrentTime = '13:15';
  final String playbackDuration = '8h 27m';
  final String playbackDistance = '23.4 km';
  final String playbackPings = '47';
  final String playbackMissing = '90 min';
  final String playbackMissingWindow = '12:00–13:30';
  final String playbackZoneEntryTime = '10:30';
  final String playbackCheckInTime = '14:32';

  /// Share of the route already played, driving the scrubber fill.
  final double playbackProgress = .4;

  final List<TrackerRouteEventEntity> routeEvents = const [
    TrackerRouteEventEntity(
      kind: TrackerRouteEventKind.start,
      title: AppStrings.trackerRouteStart,
      subtitle: 'Home Address, Brooklyn',
      time: '09:15',
    ),
    TrackerRouteEventEntity(
      kind: TrackerRouteEventKind.zoneEntry,
      title: AppStrings.trackerRouteZoneEntry,
      subtitle: 'Permitted: Office Building, Manhattan',
      time: '10:30',
    ),
    TrackerRouteEventEntity(
      kind: TrackerRouteEventKind.missingBegin,
      title: AppStrings.trackerMissingIntervalBegin,
      subtitle: '90 min gap',
      note: AppStrings.trackerMissingBeginNote,
      time: '12:00',
    ),
    TrackerRouteEventEntity(
      kind: TrackerRouteEventKind.missingEnd,
      title: AppStrings.trackerMissingIntervalEnd,
      subtitle: 'Location signal resumed',
      note: AppStrings.trackerMissingEndNote,
      time: '13:30',
    ),
    TrackerRouteEventEntity(
      kind: TrackerRouteEventKind.checkIn,
      title: AppStrings.trackerRouteCheckIn,
      subtitle: 'Office Building, Manhattan',
      time: '14:32',
    ),
    TrackerRouteEventEntity(
      kind: TrackerRouteEventKind.end,
      title: AppStrings.trackerRouteEnd,
      subtitle: 'Office Building, Manhattan',
      time: '17:42',
    ),
  ];

  String playbackRange = AppStrings.trackerRangeToday;
  String playbackSpeed = AppStrings.trackerSpeed1x;
  bool isPlaying = false;

  void setPlaybackRange(String value) {
    playbackRange = value;
    notifyListeners();
  }

  void setPlaybackSpeed(String value) {
    playbackSpeed = value;
    notifyListeners();
  }

  void togglePlayback() {
    isPlaying = !isPlaying;
    notifyListeners();
  }

  // -------------------------------------------------------- live tracking

  final String liveLocation = 'Times Square, Manhattan, NY';
  final String liveCoordinates = '40.7580° N, 73.9855° W';

  final List<TrackerLiveStatEntity> liveStats = const [
    TrackerLiveStatEntity(
      label: AppStrings.trackerLastCheckIn,
      value: '14:30',
      subtitle: 'Office Building',
    ),
    TrackerLiveStatEntity(
      label: AppStrings.trackerActiveZones,
      value: '1 Permitted',
      subtitle: 'Manhattan Office',
    ),
  ];

  final List<TrackerLivePingEntity> livePings = const [
    TrackerLivePingEntity(
        time: '14:32', location: 'Times Square, Manhattan, NY'),
    TrackerLivePingEntity(
        time: '14:18', location: '7th Ave & W 43rd St, Manhattan, NY'),
    TrackerLivePingEntity(
        time: '14:05', location: "Hell's Kitchen, Manhattan, NY"),
  ];

  /// The design ships the connected state; "Simulate Offline" flips this so
  /// the viewer can see how a dropped signal reads.
  bool isLiveOnline = true;
  String liveUpdated = AppStrings.trackerJustNow;

  void toggleLiveConnection() {
    isLiveOnline = !isLiveOnline;
    notifyListeners();
  }

  void refreshLive() {
    liveUpdated = AppStrings.trackerJustNow;
    notifyListeners();
  }

  // ------------------------------------------------------------ check-ins

  static const List<String> checkInFilters = [
    AppStrings.trackerFilterAll,
    AppStrings.trackerFilterUpcoming,
    AppStrings.trackerFilterCompleted,
    AppStrings.trackerFilterMissed,
    AppStrings.trackerFilterEscalated,
  ];

  final String completedCheckIns = '4';
  final String missedCheckInsCount = '1';
  final String upcomingCheckIns = '1';

  final List<TrackerCheckInEntity> checkIns = const [
    TrackerCheckInEntity(
      title: AppStrings.trackerOfficeCheckIn,
      schedule: 'Today · 14:30',
      detail: 'Completed at 14:31 · 1 min early',
      status: TrackerCheckInStatus.completed,
      hasPhoto: true,
    ),
    TrackerCheckInEntity(
      title: AppStrings.trackerEveningCheckIn,
      schedule: 'Today · 18:00',
      detail: 'Due in 3h 22m',
      status: TrackerCheckInStatus.upcoming,
    ),
    TrackerCheckInEntity(
      title: AppStrings.trackerOfficeCheckIn,
      schedule: 'Yesterday · 14:30',
      detail: 'Completed on time',
      status: TrackerCheckInStatus.completed,
      hasPhoto: true,
    ),
    TrackerCheckInEntity(
      title: AppStrings.trackerMorningCheckIn,
      schedule: 'Dec 10 · 10:00',
      detail: '45 min grace period expired',
      status: TrackerCheckInStatus.escalated,
      note: AppStrings.trackerEscalationNote,
      hasEscalatedTag: true,
    ),
    TrackerCheckInEntity(
      title: AppStrings.trackerOfficeCheckIn,
      schedule: 'Dec 9 · 14:30',
      detail: 'Completed 2 min early',
      status: TrackerCheckInStatus.completed,
      hasPhoto: true,
    ),
    TrackerCheckInEntity(
      title: AppStrings.trackerOfficeCheckIn,
      schedule: 'Dec 8 · 14:30',
      detail: 'Completed on time',
      status: TrackerCheckInStatus.completed,
      hasPhoto: true,
    ),
  ];

  String checkInFilter = AppStrings.trackerFilterAll;

  /// An escalated check-in was also a missed one, so it answers both chips.
  List<TrackerCheckInEntity> get visibleCheckIns => checkIns.where((checkIn) {
        return switch (checkInFilter) {
          AppStrings.trackerFilterUpcoming =>
            checkIn.status == TrackerCheckInStatus.upcoming,
          AppStrings.trackerFilterCompleted =>
            checkIn.status == TrackerCheckInStatus.completed,
          AppStrings.trackerFilterMissed =>
            checkIn.status == TrackerCheckInStatus.missed ||
                checkIn.status == TrackerCheckInStatus.escalated,
          AppStrings.trackerFilterEscalated =>
            checkIn.status == TrackerCheckInStatus.escalated,
          _ => true,
        };
      }).toList();

  void setCheckInFilter(String value) {
    checkInFilter = value;
    notifyListeners();
  }
}

final trackerUsersControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackerUsersController>(
  (ref) => TrackerUsersController(),
);
