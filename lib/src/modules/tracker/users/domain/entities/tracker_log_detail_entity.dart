import '../../../../../core/utils/app_exports.dart';

/// A label/value row on the log detail screen. [locked] adds the amber padlock
/// that marks a field as part of the sealed record; [monospace] is for the
/// machine-written values (coordinates, timestamps).
class TrackerLogFieldEntity {
  const TrackerLogFieldEntity({
    required this.label,
    required this.value,
    this.locked = false,
    this.monospace = false,
    this.icon,
    this.valueColor,
    this.leadingDot = false,
  });

  final String label;
  final String value;
  final bool locked;
  final bool monospace;

  /// Drawn before the value, for the device row.
  final String? icon;
  final Color? valueColor;

  /// A filled status dot before the value, as on the sync status row.
  final bool leadingDot;
}

/// One band of the authenticity scale, shown as a legend under the score.
class TrackerLogScoreBandEntity {
  const TrackerLogScoreBandEntity({
    required this.label,
    required this.range,
    required this.color,
    required this.fill,
    required this.border,
  });

  final String label;
  final String range;
  final Color color;
  final Color fill;
  final Color border;
}

/// A single immutable GPS log, opened from a recent activity row or an alert.
class TrackerLogDetailEntity {
  const TrackerLogDetailEntity({
    required this.sequence,
    required this.status,
    required this.kindLabel,
    required this.kindColor,
    required this.kindFill,
    required this.timestamp,
    required this.score,
    required this.scoreColor,
    required this.scoreNote,
    required this.gpsFields,
    required this.syncFields,
    required this.eventFields,
    required this.notes,
    required this.attachmentSummary,
    required this.mediaCaption,
  });

  /// The log's position in the day's sequence, shown top-left.
  final String sequence;
  final String status;
  final String kindLabel;
  final Color kindColor;
  final Color kindFill;
  final String timestamp;
  final String score;
  final Color scoreColor;
  final String scoreNote;
  final List<TrackerLogFieldEntity> gpsFields;
  final List<TrackerLogFieldEntity> syncFields;
  final List<TrackerLogFieldEntity> eventFields;
  final String notes;
  final String attachmentSummary;
  final String mediaCaption;
}
