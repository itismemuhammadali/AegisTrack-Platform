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
