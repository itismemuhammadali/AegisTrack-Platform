import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracked_sync_log_entry_entity.dart';

class TrackedSyncStatusController extends ChangeNotifier with Buffers {
  List<TrackedSyncLogEntryEntity> _entries = const [
    TrackedSyncLogEntryEntity(
      coordinates: '37.7749° N, 122.4194° W',
      timestamp: '2 min ago',
      status: TrackedSyncLogStatus.pending,
    ),
    TrackedSyncLogEntryEntity(
      coordinates: '37.7750° N, 122.4195° W',
      timestamp: '5 min ago',
      status: TrackedSyncLogStatus.pending,
    ),
    TrackedSyncLogEntryEntity(
      coordinates: '37.7748° N, 122.4193° W',
      timestamp: '8 min ago',
      status: TrackedSyncLogStatus.pending,
    ),
    TrackedSyncLogEntryEntity(
      coordinates: '37.7751° N, 122.4196° W',
      timestamp: '15 min ago',
      status: TrackedSyncLogStatus.failed,
      failureReason: 'Network timeout',
    ),
    TrackedSyncLogEntryEntity(
      coordinates: '37.7752° N, 122.4197° W',
      timestamp: '1 hour ago',
      status: TrackedSyncLogStatus.synced,
    ),
    TrackedSyncLogEntryEntity(
      coordinates: '37.7753° N, 122.4198° W',
      timestamp: '2 hours ago',
      status: TrackedSyncLogStatus.synced,
    ),
    TrackedSyncLogEntryEntity(
      coordinates: '37.7754° N, 122.4199° W',
      timestamp: '3 hours ago',
      status: TrackedSyncLogStatus.synced,
    ),
  ];

  List<TrackedSyncLogEntryEntity> get entries => _entries;

  List<TrackedSyncLogEntryEntity> get pendingEntries => _entries
      .where((entry) => entry.status == TrackedSyncLogStatus.pending)
      .toList();

  List<TrackedSyncLogEntryEntity> get failedEntries => _entries
      .where((entry) => entry.status == TrackedSyncLogStatus.failed)
      .toList();

  List<TrackedSyncLogEntryEntity> get syncedEntries => _entries
      .where((entry) => entry.status == TrackedSyncLogStatus.synced)
      .toList();

  void retrySync(TrackedSyncLogEntryEntity entry) {
    final index = _entries.indexOf(entry);
    if (index == -1) return;
    _entries = [
      for (var i = 0; i < _entries.length; i++)
        if (i == index)
          TrackedSyncLogEntryEntity(
            coordinates: entry.coordinates,
            timestamp: entry.timestamp,
            status: TrackedSyncLogStatus.synced,
          )
        else
          _entries[i],
    ];
    notifyListeners();
  }

  void syncNow() {
    _entries = [
      for (final entry in _entries)
        if (entry.status == TrackedSyncLogStatus.pending)
          TrackedSyncLogEntryEntity(
            coordinates: entry.coordinates,
            timestamp: entry.timestamp,
            status: TrackedSyncLogStatus.synced,
          )
        else
          entry,
    ];
    notifyListeners();
  }
}

final trackedSyncStatusControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackedSyncStatusController>(
  (ref) => TrackedSyncStatusController(),
);
