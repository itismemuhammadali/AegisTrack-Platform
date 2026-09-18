import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracked_ai_result_entity.dart';

enum TrackedAiSearchState { idle, searching, results }

class TrackedAiController extends ChangeNotifier with Buffers {
  final TextEditingController queryController = TextEditingController();
  final List<String> suggestions = AppStrings.trackedAiSuggestions;

  TrackedAiSearchState state = TrackedAiSearchState.idle;
  String submittedQuery = '';
  List<TrackedAiResultEntity> results = const [];

  bool get isIdle => state == TrackedAiSearchState.idle;

  Future<void> search({String? query, ValueChanged<String>? onSearch}) async {
    if (query != null) queryController.text = query;
    final value = queryController.text.trim();
    if (value.isEmpty || state == TrackedAiSearchState.searching) return;

    FocusManager.instance.primaryFocus?.unfocus();
    submittedQuery = value;
    state = TrackedAiSearchState.searching;
    notifyListeners();
    onSearch?.call(value);

    // TODO: replace with the AI search API; mock results match Figma.
    await Future.delayed(const Duration(milliseconds: 1500));
    if (state != TrackedAiSearchState.searching) return;
    results = _mockResults;
    state = TrackedAiSearchState.results;
    notifyListeners();
  }

  /// Back from searching/results to the suggestions list.
  void reset() {
    queryController.clear();
    submittedQuery = '';
    results = const [];
    state = TrackedAiSearchState.idle;
    notifyListeners();
  }

  static final List<TrackedAiResultEntity> _mockResults = [
    TrackedAiResultEntity(
      icon: AppAssetsSvg.trackedAiResultLocation,
      iconBackground: AppColors.primaryWhite.withValues(alpha: 0.1),
      title: 'Office District',
      subtitle: '37.7749° N, 122.4194° W',
      timestamp: 'Monday, Apr 14 · 10:30 AM',
    ),
    TrackedAiResultEntity(
      icon: AppAssetsSvg.trackedAiResultCheckIn,
      iconBackground: AppColors.trackedZoneAllowedGreen.withValues(alpha: 0.13),
      title: 'Check-in Completed',
      subtitle: 'Daily · Biometric verified',
      timestamp: 'Monday, Apr 14 · 9:00 AM',
    ),
    TrackedAiResultEntity(
      icon: AppAssetsSvg.trackedAiResultZone,
      iconBackground: AppColors.trackedCheckInAmber.withValues(alpha: 0.13),
      title: 'Zone Entry — Work Site Alpha',
      subtitle: 'Allowed area event logged',
      timestamp: 'Monday, Apr 14 · 8:45 AM',
    ),
  ];

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }
}

final trackedAiControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackedAiController>(
  (ref) => TrackedAiController(),
);
