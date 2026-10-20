import '../../../../../core/utils/app_exports.dart';

class TrackerActivityEntity {
  const TrackerActivityEntity({
    required this.time,
    required this.label,
    required this.location,
    required this.color,
  });

  final String time;
  final String label;
  final String location;
  final Color color;
}
