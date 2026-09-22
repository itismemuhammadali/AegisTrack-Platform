import '../../../../../core/utils/app_exports.dart';

/// Alert kinds in the viewer alert centre. Each carries its icon, the colour
/// of its icon circle, the tinted card it sits in and the chip it answers to.
enum TrackerNotificationKind {
  sos(
    label: AppStrings.trackerAlertSosEmergency,
    icon: AppAssetsSvg.trackerAlertCenterSos,
    iconFill: AppColors.trackerAlertRedIconFill,
    cardFill: AppColors.trackerAlertRedCardFill,
    cardBorder: AppColors.trackerAlertRedCardBorder,
    filter: AppStrings.trackerFilterSos,
    hasGlow: true,
  ),
  restrictedZone(
    label: AppStrings.trackerAlertRestrictedZoneEntry,
    icon: AppAssetsSvg.trackerAlertCenterZone,
    iconFill: AppColors.trackerAlertOrangeIconFill,
    cardFill: AppColors.trackerAlertOrangeCardFill,
    cardBorder: AppColors.trackerAlertOrangeCardBorder,
    filter: AppStrings.trackerFilterRestrictedZone,
  ),
  missedCheckIn(
    label: AppStrings.trackerAlertMissedCheckIn,
    icon: AppAssetsSvg.trackerAlertCenterMissed,
    iconFill: AppColors.trackerAlertAmberIconFill,
    cardFill: AppColors.trackerAlertAmberCardFill,
    cardBorder: AppColors.trackerAlertAmberCardBorder,
    filter: AppStrings.trackerFilterMissedCheckIn,
  ),
  antiSpoofing(
    label: AppStrings.trackerAlertAntiSpoofing,
    icon: AppAssetsSvg.trackerAlertCenterSpoofing,
    iconFill: AppColors.trackerAlertRedIconFill,
    cardFill: AppColors.trackerAlertRedCardFill,
    cardBorder: AppColors.trackerAlertRedCardBorder,
    filter: AppStrings.trackerFilterSecurity,
  ),
  missingLog(
    label: AppStrings.trackerAlertMissingLogInterval,
    icon: AppAssetsSvg.trackerAlertCenterMissingLog,
    iconFill: AppColors.trackerBorderSoft,
    filter: AppStrings.trackerFilterMissingLogs,
  ),
  securityEvent(
    label: AppStrings.trackerAlertSecurityEvent,
    icon: AppAssetsSvg.trackerAlertCenterSecurity,
    iconFill: AppColors.trackerAlertBlueIconFill,
    filter: AppStrings.trackerFilterSecurity,
  );

  const TrackerNotificationKind({
    required this.label,
    required this.icon,
    required this.iconFill,
    required this.filter,
    this.cardFill,
    this.cardBorder,
    this.hasGlow = false,
  });

  final String label;
  final String icon;
  final Color iconFill;
  final String filter;

  /// Tinted card; kinds without one use the neutral surface.
  final Color? cardFill;
  final Color? cardBorder;

  /// The SOS alert carries a soft halo behind its icon.
  final bool hasGlow;
}

enum TrackerNotificationSeverity {
  critical(
    label: AppStrings.trackerSeverityCritical,
    color: AppColors.primaryWhite,
    fill: AppColors.trackerAlertCriticalRed,
  ),
  high(
    label: AppStrings.trackerSeverityHigh,
    color: AppColors.trackerOrange,
    fill: AppColors.trackerAlertOrangeIconFill,
  ),
  medium(
    label: AppStrings.trackerSeverityMedium,
    color: AppColors.trackerAcceptableText,
    fill: AppColors.trackerAlertAmberIconFill,
  ),
  low(
    label: AppStrings.trackerSeverityLow,
    color: AppColors.primaryWhite,
    fill: AppColors.trackerBorderSoft,
  );

  const TrackerNotificationSeverity({
    required this.label,
    required this.color,
    required this.fill,
  });

  final String label;
  final Color color;
  final Color fill;
}

class TrackerNotificationEntity {
  const TrackerNotificationEntity({
    required this.kind,
    required this.name,
    required this.detail,
    required this.time,
    required this.severity,
    this.isUnread = false,
  });

  final TrackerNotificationKind kind;
  final String name;
  final String detail;
  final String time;
  final TrackerNotificationSeverity severity;

  /// Shows the blue dot beside the kind label.
  final bool isUnread;
}

class TrackerNotificationGroupEntity {
  const TrackerNotificationGroupEntity(
      {required this.title, required this.alerts});

  final String title;
  final List<TrackerNotificationEntity> alerts;
}
