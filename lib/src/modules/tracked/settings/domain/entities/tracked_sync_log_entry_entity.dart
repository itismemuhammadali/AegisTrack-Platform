import '../../../../../core/utils/app_enums.dart';

class TrackedSyncLogEntryEntity {
  const TrackedSyncLogEntryEntity({
    required this.coordinates,
    required this.timestamp,
    required this.status,
    this.failureReason,
  });

  final String coordinates;
  final String timestamp;
  final TrackedSyncLogStatus status;
  final String? failureReason;
}
