import '../../../../../core/utils/app_exports.dart';

/// A choice on one of the wizard's radio steps: what to share, or how long
/// the link should live.
class TrackerShareOptionEntity {
  const TrackerShareOptionEntity({
    required this.title,
    required this.subtitle,
    this.icon,
    this.badge = '',
  });

  final String title;
  final String subtitle;

  /// Only the content step draws an icon tile beside the text.
  final String? icon;

  /// Marks an option gated behind a plan, as Live Activity is.
  final String badge;
}

/// A row on the review step.
class TrackerShareReviewEntity {
  const TrackerShareReviewEntity({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String icon;
  final String label;
  final String value;
  final Color? valueColor;
}

/// Lifecycle of a generated link, carrying the colours its pill is drawn with.
enum TrackerShareLinkStatus {
  active(
    label: AppStrings.trackerShareStatusActive,
    color: AppColors.trackerOnlineGreen,
    fill: AppColors.trackerShareActiveFill,
    border: AppColors.trackerShareActiveBorder,
  ),
  expired(
    label: AppStrings.trackerShareStatusExpired,
    color: AppColors.primaryWhite,
    fill: AppColors.trackerSurfaceFill,
    border: AppColors.trackerSurfaceFill,
  ),
  revoked(
    label: AppStrings.trackerShareStatusRevoked,
    color: AppColors.trackerFlaggedRed,
    fill: AppColors.trackerShareRevokedFill,
    border: AppColors.trackerShareRevokedBorder,
  );

  const TrackerShareLinkStatus({
    required this.label,
    required this.color,
    required this.fill,
    required this.border,
  });

  final String label;
  final Color color;
  final Color fill;
  final Color border;

  /// A revoked link's URL is struck through; the others read normally.
  bool get isStruckThrough => this == TrackerShareLinkStatus.revoked;

  /// Only a live link can still be pulled.
  bool get isRevocable => this == TrackerShareLinkStatus.active;
}

/// A share link in the All Links list.
class TrackerShareLinkEntity {
  const TrackerShareLinkEntity({
    required this.url,
    required this.description,
    required this.expires,
    required this.status,
  });

  final String url;
  final String description;
  final String expires;
  final TrackerShareLinkStatus status;
}
