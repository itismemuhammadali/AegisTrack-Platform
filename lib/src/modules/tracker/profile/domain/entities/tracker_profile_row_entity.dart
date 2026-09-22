import '../../../../../core/utils/app_exports.dart';

class TrackerProfileRowEntity {
  const TrackerProfileRowEntity({
    required this.label,
    required this.icon,
    this.value = '',
    this.valueIsBadge = false,
    this.valueColor,
    this.opensAssignedUsers = false,
  });

  final String label;
  final String icon;
  final String value;

  /// Renders [value] as a pill instead of plain text.
  final bool valueIsBadge;
  final Color? valueColor;

  /// Switches the dashboard to the assigned users tab instead of [onAction].
  final bool opensAssignedUsers;
}

class TrackerProfileSectionEntity {
  const TrackerProfileSectionEntity({required this.title, required this.rows});

  final String title;
  final List<TrackerProfileRowEntity> rows;
}

/// A way to reach support from the Help & Support screen.
class TrackerHelpChannelEntity {
  const TrackerHelpChannelEntity({
    required this.icon,
    required this.iconFill,
    required this.title,
    required this.subtitle,
  });

  final String icon;
  final Color iconFill;
  final String title;
  final String subtitle;
}

/// One row of the plan comparison table: the feature, and whether each tier
/// includes it. [tiers] is ordered Free, Basic, Pro, Expert.
class TrackerPlanFeatureEntity {
  const TrackerPlanFeatureEntity({required this.label, required this.tiers});

  final String label;
  final List<bool> tiers;
}
