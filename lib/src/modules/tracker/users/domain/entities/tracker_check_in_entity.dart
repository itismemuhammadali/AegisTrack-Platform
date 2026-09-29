import '../../../../../core/utils/app_exports.dart';

/// Status of a scheduled check-in; carries its icon, pill colours and the
/// card border the escalated state gets.
enum TrackerCheckInStatus {
  completed(
    label: AppStrings.trackerStatusCompleted,
    icon: AppAssetsSvg.trackerCheckInCompleted,
    color: AppColors.trackerOnlineGreen,
    fill: AppColors.trackerOnlinePillFill,
    border: AppColors.trackerOnlinePillBorder,
  ),
  upcoming(
    label: AppStrings.trackerStatusUpcoming,
    icon: AppAssetsSvg.trackerCheckInUpcoming,
    color: AppColors.trackerInfoBlue,
    fill: AppColors.trackerUpcomingPillFill,
    border: AppColors.trackerUpcomingPillBorder,
  ),
  escalated(
    label: AppStrings.trackerStatusEscalated,
    icon: AppAssetsSvg.trackerCheckInEscalated,
    color: AppColors.trackerFlaggedRed,
    fill: AppColors.trackerDangerPillFill,
    border: AppColors.trackerDangerPillBorder,
    cardBorder: AppColors.trackerDangerPillBorder,
  ),
  missed(
    label: AppStrings.trackerStatusMissed,
    icon: AppAssetsSvg.trackerCheckInEscalated,
    color: AppColors.trackerFlaggedRed,
    fill: AppColors.trackerDangerPillFill,
    border: AppColors.trackerDangerPillBorder,
  );

  const TrackerCheckInStatus({
    required this.label,
    required this.icon,
    required this.color,
    required this.fill,
    required this.border,
    this.cardBorder,
  });

  final String label;
  final String icon;
  final Color color;
  final Color fill;
  final Color border;
  final Color? cardBorder;
}

class TrackerCheckInEntity {
  const TrackerCheckInEntity({
    required this.title,
    required this.schedule,
    required this.detail,
    required this.status,
    this.note,
    this.hasPhoto = false,
    this.hasEscalatedTag = false,
  });

  final String title;

  /// When it was due, e.g. "Today · 14:30".
  final String schedule;

  /// How it resolved, e.g. "Completed at 14:31 · 1 min early".
  final String detail;
  final TrackerCheckInStatus status;

  /// Amber explainer under an escalated check-in.
  final String? note;
  final bool hasPhoto;

  /// Inline ESCALATED tag beside the title.
  final bool hasEscalatedTag;
}
