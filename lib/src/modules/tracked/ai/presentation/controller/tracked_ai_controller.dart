import '../../../../../core/utils/app_exports.dart';

class TrackedAiController extends ChangeNotifier with Buffers {
  final TextEditingController queryController = TextEditingController();
  final List<String> suggestions = AppStrings.trackedAiSuggestions;

  void search({String? query, ValueChanged<String>? onSearch}) {
    if (query != null) queryController.text = query;
    final value = queryController.text.trim();
    if (value.isEmpty) return;
    onSearch?.call(value);
  }

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
