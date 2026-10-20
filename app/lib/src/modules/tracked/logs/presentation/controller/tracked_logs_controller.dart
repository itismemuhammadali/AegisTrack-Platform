import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracked_log_entry_entity.dart';

class TrackedLogsController extends ChangeNotifier with Buffers {
  TrackedLogsController() {
    locator<MockDataService>().addListener(_onMockDataChanged);
  }

  void _onMockDataChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    locator<MockDataService>().removeListener(_onMockDataChanged);
    super.dispose();
  }

  List<TrackedLogEntryEntity> get entries => locator<MockDataService>().trackedLogs;
}

final trackedLogsControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackedLogsController>(
  (ref) => TrackedLogsController(),
);
