enum TrackedLogStatus { synced, pending, failed }

class TrackedLogEntryEntity {
  const TrackedLogEntryEntity({
    required this.location,
    required this.timestamp,
    required this.status,
    this.tags = const [],
  });

  final String location;
  final String timestamp;
  final TrackedLogStatus status;
  final List<String> tags;
}
