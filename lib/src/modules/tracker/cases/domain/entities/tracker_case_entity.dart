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
