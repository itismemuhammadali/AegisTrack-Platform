enum TrackedCheckInStatus { upcoming, completed, missed }

class TrackedCheckInEntity {
  const TrackedCheckInEntity({
    required this.time,
    required this.day,
    required this.detail,
    required this.status,
  });

  final String time;
  final String day;
  final String detail;
  final TrackedCheckInStatus status;
}
