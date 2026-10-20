import '../../../../../core/utils/app_exports.dart';

/// Stops on the playback route timeline. [missingBegin] and [missingEnd]
/// carry the amber highlight the design gives an unrecorded interval.
enum TrackerRouteEventKind {
  start(color: AppColors.trackerSuccessGreen),
  zoneEntry(icon: AppAssetsSvg.trackerMapPlaybackZonePin),
  missingBegin(
    icon: AppAssetsSvg.trackerTimelineMissing,
    borderColor: AppColors.trackerWarningBorder,
  ),
  missingEnd(
    icon: AppAssetsSvg.trackerTimelineMissing,
    borderColor: AppColors.trackerWarningBorder,
  ),
  checkIn(icon: AppAssetsSvg.trackerTimelineCheckIn),
  end(color: AppColors.trackerDangerRed);

  const TrackerRouteEventKind({this.icon, this.color, this.borderColor});

  /// Leading icon; kinds without one render a filled [color] dot instead.
  final String? icon;
  final Color? color;
  final Color? borderColor;
}

class TrackerRouteEventEntity {
  const TrackerRouteEventEntity({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.time,
    this.note,
  });

  final TrackerRouteEventKind kind;
  final String title;
  final String subtitle;
  final String time;

  /// Amber explainer line shown on the missing-interval rows.
  final String? note;
}
