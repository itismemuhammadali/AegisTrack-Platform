import '../../../../../core/utils/app_exports.dart';

/// Authenticity band, carrying the label, colours and note the overview
/// draws it with.
enum TrackerAuthenticity {
  verified(
    label: AppStrings.trackerVerified,
    color: AppColors.trackerOnlineGreen,
    badgeFill: AppColors.trackerOnlinePillFill,
    note: AppStrings.trackerAuthenticityScoreNote,
  ),
  acceptable(
    label: AppStrings.trackerAcceptableBadge,
    color: AppColors.trackerAcceptableText,
    badgeFill: AppColors.trackerAcceptableSurface,
    note: AppStrings.trackerAcceptableNote,
  ),
  questionable(
    label: AppStrings.trackerQuestionableBadge,
    color: AppColors.trackerOrange,
    badgeFill: AppColors.trackerOrangeSurface,
    note: AppStrings.trackerQuestionableNote,
  ),
  suspect(
    label: AppStrings.trackerScoreSuspect,
    color: AppColors.trackerSuspectRed,
    badgeFill: AppColors.trackerSuspectFill,
    note: AppStrings.trackerSuspectNote,
  );

  const TrackerAuthenticity({
    required this.label,
    required this.color,
    required this.badgeFill,
    required this.note,
  });

  final String label;
  final Color color;
  final Color badgeFill;
  final String note;
}

class TrackerUserEntity {
  const TrackerUserEntity({
    required this.name,
    required this.lastSeen,
    required this.location,
    required this.authenticity,
    this.isOnline = true,
    this.isSos = false,
    this.isIdentified = true,
    this.score = '94',
    this.trend = AppStrings.trackerTrendStable,
    this.lastLog = '',
    this.lastSync = '14:32 today',
    this.activeAlerts = '2',
    this.missedCheckIns = '1',
    this.zoneEvents = '3 today',
    this.securityFlags = '0',
  });

  final String name;
  final String lastSeen;
  final String location;
  final TrackerAuthenticity authenticity;
  final bool isOnline;
  final bool isSos;

  /// An unidentified subject: the overview has no history to show, so its
  /// metrics read Unknown / N/A.
  final bool isIdentified;

  // The overview's per-user figures. Defaults match the verified sample the
  // design leads with.
  final String score;
  final String trend;

  /// Overrides the time parsed out of [lastSeen] when the two differ.
  final String lastLog;
  final String lastSync;
  final String activeAlerts;
  final String missedCheckIns;
  final String zoneEvents;
  final String securityFlags;

  /// Drives the Security Flags card: clean when nothing was raised.
  bool get hasSecurityFlags => securityFlags != '0';
}
