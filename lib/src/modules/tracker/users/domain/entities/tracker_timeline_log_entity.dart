import '../../../../../core/utils/app_exports.dart';

/// The log kinds shown on the viewer timeline; each drives its own icon,
/// badge colour and (for [missing] / [sos]) the card highlight.
enum TrackerTimelineLogKind {
  checkIn(
    label: AppStrings.trackerLogCheckIn,
    icon: AppAssetsSvg.trackerTimelineCheckIn,
    accent: AppColors.trackerInfoBlue,
    surface: AppColors.trackerInfoBlueSurface,
    filter: AppStrings.trackerFilterCheckIns,
  ),
  zoneEvent(
    label: AppStrings.trackerLogZoneEvent,
    icon: AppAssetsSvg.trackerTimelineZone,
    accent: AppColors.trackerOrange,
    surface: AppColors.trackerOrangeSurface,
    filter: AppStrings.trackerFilterZoneEvents,
  ),
  missing(
    label: AppStrings.trackerLogMissing,
    icon: AppAssetsSvg.trackerTimelineMissing,
    accent: AppColors.trackerAmber,
    surface: AppColors.trackerAmberSurface,
    filter: AppStrings.trackerFilterMissing,
    cardFill: AppColors.trackerMissingCardFill,
    cardBorder: AppColors.trackerMissingCardBorder,
  ),
  securityFlag(
    label: AppStrings.trackerLogSecurityFlag,
    icon: AppAssetsSvg.trackerTimelineSecurityFlag,
    accent: AppColors.trackerFlaggedRed,
    surface: AppColors.trackerDangerSurface,
    filter: AppStrings.trackerFilterSecurityFlags,
  ),
  location(
    label: AppStrings.trackerLogLocation,
    icon: AppAssetsSvg.trackerTimelineMap,
    accent: AppColors.primaryWhite,
    surface: AppColors.trackerNeutralSurface,
  ),
  sos(
    label: AppStrings.trackerLogSos,
    icon: AppAssetsSvg.trackerTimelineSos,
    accent: AppColors.trackerFlaggedRed,
    surface: AppColors.trackerDangerSurface,
    filter: AppStrings.trackerLogSos,
    cardFill: AppColors.trackerSosCardFill,
    cardBorder: AppColors.trackerSosCardBorder,
    hasGlow: true,
  );

  const TrackerTimelineLogKind({
    required this.label,
    required this.icon,
    required this.accent,
    required this.surface,
    this.filter,
    this.cardFill,
    this.cardBorder,
    this.hasGlow = false,
  });

  final String label;
  final String icon;
  final Color accent;
  final Color surface;

  /// Filter chip this kind answers to, when it has one.
  final String? filter;
  final Color? cardFill;
  final Color? cardBorder;
  final bool hasGlow;
}

/// A tinted icon + label pair, used for the status line and the footer tags.
class TrackerTimelineTagEntity {
  const TrackerTimelineTagEntity({
    required this.label,
    required this.color,
    this.icon,
  });

  final String label;
  final Color color;
  final String? icon;
}

class TrackerTimelineAuthenticityEntity {
  const TrackerTimelineAuthenticityEntity({
    required this.label,
    required this.color,
    required this.background,
  });

  const TrackerTimelineAuthenticityEntity.verified(String score)
      : label = '$score · VERIFIED',
        color = AppColors.trackerOnlineGreen,
        background = AppColors.trackerSuccessSurface;

  const TrackerTimelineAuthenticityEntity.acceptable(String score)
      : label = '$score · ACCEPTABLE',
        color = AppColors.trackerAcceptableText,
        background = AppColors.trackerAcceptableSurface;

  final String label;
  final Color color;
  final Color background;
}

class TrackerTimelineLogEntity {
  const TrackerTimelineLogEntity({
    required this.name,
    required this.kind,
    required this.time,
    required this.location,
    this.timeTag,
    this.status,
    this.authenticity,
    this.tags = const [],
    this.isOffline = false,
  });

  final String name;
  final TrackerTimelineLogKind kind;
  final String time;
  final String location;

  /// Chip rendered beside the time, e.g. OFFLINE.
  final TrackerTimelineTagEntity? timeTag;

  /// Coloured line under the location, e.g. "Entered: Permitted Zone".
  final TrackerTimelineTagEntity? status;
  final TrackerTimelineAuthenticityEntity? authenticity;
  final List<TrackerTimelineTagEntity> tags;
  final bool isOffline;
}

class TrackerTimelineGroupEntity {
  const TrackerTimelineGroupEntity({required this.title, required this.logs});

  final String title;
  final List<TrackerTimelineLogEntity> logs;
}
