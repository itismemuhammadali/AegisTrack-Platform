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

/// A signed-in device on the security screen.
class TrackerSessionEntity {
  const TrackerSessionEntity({
    required this.device,
    required this.location,
    required this.lastActive,
    this.isCurrent = false,
  });

  final String device;
  final String location;
  final String lastActive;

  /// The device being used now cannot be revoked from itself.
  final bool isCurrent;
}

/// Theme choice, carrying the icon and headline each option shows.
enum TrackerThemeMode {
  dark(
    icon: AppAssetsSvg.trackerThemeDark,
    title: AppStrings.trackerThemeDarkTitle,
    note: AppStrings.trackerThemeDarkNote,
    activeLabel: AppStrings.trackerThemeDarkActive,
  ),
  light(
    icon: AppAssetsSvg.trackerThemeLight,
    title: AppStrings.trackerThemeLightTitle,
    note: AppStrings.trackerThemeLightNote,
    activeLabel: AppStrings.trackerThemeLightActive,
  ),
  system(
    icon: AppAssetsSvg.trackerThemeSystem,
    title: AppStrings.trackerThemeSystemTitle,
    note: AppStrings.trackerThemeSystemNote,
    activeLabel: AppStrings.trackerThemeSystemActive,
  );

  const TrackerThemeMode({
    required this.icon,
    required this.title,
    required this.note,
    required this.activeLabel,
  });

  final String icon;
  final String title;
  final String note;

  /// Shown under "Current Theme" when this option is the chosen one.
  final String activeLabel;
}

/// A notification switch, kept as data so the three lists render from loops.
class TrackerNotificationToggleEntity {
  const TrackerNotificationToggleEntity({
    required this.title,
    required this.value,
    required this.onToggle,
    this.note = '',
    this.icon,
    this.emoji = '',
  });

  final String title;
  final bool value;
  final VoidCallback onToggle;
  final String note;
  final String? icon;

  /// Some rows use an emoji glyph rather than an SVG, as the design does.
  final String emoji;
}
