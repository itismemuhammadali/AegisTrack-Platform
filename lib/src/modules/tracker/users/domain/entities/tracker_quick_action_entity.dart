import '../../../../../core/utils/app_exports.dart';

class TrackerQuickActionEntity {
  const TrackerQuickActionEntity({
    required this.label,
    required this.icon,
    this.badge,
    this.badgeColor,
  });

  final String label;
  final String icon;
  final String? badge;
  final Color? badgeColor;
}
