import '../../../../../core/utils/app_exports.dart';

class TrackerCasePersonEntity {
  const TrackerCasePersonEntity({required this.initials, required this.name});

  final String initials;
  final String name;
}

class TrackerCaseEntity {
  const TrackerCaseEntity({
    required this.id,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.people,
    required this.evidence,
    required this.date,
    this.legalHold = false,
  });

  final String id;
  final String title;
  final String status;
  final Color statusColor;
  final List<TrackerCasePersonEntity> people;
  final String evidence;
  final String date;
  final bool legalHold;
}

/// A label/value row in the case information section.
class TrackerCaseInfoEntity {
  const TrackerCaseInfoEntity({required this.label, required this.value});

  final String label;
  final String value;
}

/// A subject monitored under the case, with their latest authenticity score.
class TrackerCaseSubjectEntity {
  const TrackerCaseSubjectEntity({
    required this.initials,
    required this.name,
    required this.role,
    required this.score,
    required this.scoreColor,
  });

  final String initials;
  final String name;
  final String role;
  final String score;
  final Color scoreColor;
}

/// One tile of the evidence summary grid.
class TrackerCaseEvidenceStatEntity {
  const TrackerCaseEvidenceStatEntity({
    required this.icon,
    required this.value,
    required this.label,
  });

  final String icon;
  final String value;
  final String label;
}

/// Kind of case timeline entry, carrying the tag colours it is drawn with.
enum TrackerCaseEventKind {
  checkIn(
    label: AppStrings.trackerCaseTagCheckIn,
    color: AppColors.trackerInfoBlue,
    fill: AppColors.trackerInfoBlueSurface,
  ),
  zoneEvent(
    label: AppStrings.trackerCaseTagZoneEvent,
    color: AppColors.trackerOrange,
    fill: AppColors.trackerOrangeSurface,
  ),
  locationUpdate(
    label: AppStrings.trackerCaseTagLocationUpdate,
    color: AppColors.trackerCaseLocationPurple,
    fill: AppColors.trackerCaseLocationSurface,
  ),
  sosEvent(
    label: AppStrings.trackerCaseTagSosEvent,
    color: AppColors.trackerFlaggedRed,
    fill: AppColors.trackerDangerSurface,
  );

  const TrackerCaseEventKind({
    required this.label,
    required this.color,
    required this.fill,
  });

  final String label;
  final Color color;
  final Color fill;
}

/// One card in the case timeline.
class TrackerCaseEventEntity {
  const TrackerCaseEventEntity({
    required this.timestamp,
    required this.kind,
    required this.name,
    required this.location,
    required this.authScore,
    required this.authColor,
  });

  final String timestamp;
  final TrackerCaseEventKind kind;
  final String name;
  final String location;
  final String authScore;
  final Color authColor;
}

/// A sealed evidence record on the Evidence tab: a log id, what it came from
/// and the authenticity score it was sealed with.
class TrackerCaseEvidenceEntity {
  const TrackerCaseEvidenceEntity({
    required this.logId,
    required this.kind,
    required this.score,
    required this.scoreColor,
  });

  final String logId;
  final TrackerCaseEventKind kind;
  final String score;
  final Color scoreColor;
}

/// A generated case report, downloadable as PDF or CSV.
class TrackerCaseReportEntity {
  const TrackerCaseReportEntity({required this.title, required this.generated});

  final String title;
  final String generated;
}
