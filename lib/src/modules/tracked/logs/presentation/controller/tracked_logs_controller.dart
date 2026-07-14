import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracked_log_entry_entity.dart';

class TrackedLogsController extends ChangeNotifier with Buffers {
  final List<TrackedLogEntryEntity> entries = const [
    TrackedLogEntryEntity(
      location: 'San Francisco, CA',
      timestamp: '2026-04-15 10:30 AM',
      status: TrackedLogStatus.synced,
      tags: [AppStrings.logTagNote, AppStrings.logTagPhoto],
    ),
    TrackedLogEntryEntity(
      location: 'Oakland, CA',
      timestamp: '2026-04-15 09:15 AM',
      status: TrackedLogStatus.synced,
      tags: [AppStrings.logTagPhoto],
    ),
    TrackedLogEntryEntity(
      location: 'Berkeley, CA',
      timestamp: '2026-04-15 08:00 AM',
      status: TrackedLogStatus.pending,
      tags: [AppStrings.logTagNote],
    ),
    TrackedLogEntryEntity(
      location: 'San Jose, CA',
      timestamp: '2026-04-14 05:45 PM',
      status: TrackedLogStatus.synced,
    ),
    TrackedLogEntryEntity(
      location: 'Austin, TX',
      timestamp: '2026-04-15 09:30 AM',
      status: TrackedLogStatus.pending,
    ),
    TrackedLogEntryEntity(
      location: 'Seattle, WA',
      timestamp: '2026-04-16 11:15 AM',
      status: TrackedLogStatus.synced,
    ),
    TrackedLogEntryEntity(
      location: 'Palo Alto, CA',
      timestamp: '2026-04-14 02:30 PM',
      status: TrackedLogStatus.failed,
      tags: [AppStrings.logTagNote, AppStrings.logTagPhoto],
    ),
  ];
}

final trackedLogsControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackedLogsController>(
  (ref) => TrackedLogsController(),
);
