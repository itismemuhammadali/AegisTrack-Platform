import '../../../../../core/utils/app_exports.dart';
import '../controller/tracked_ai_controller.dart';
import '../widgets/tracked_ai_header.dart';
import '../widgets/tracked_ai_search_bar.dart';
import '../widgets/tracked_ai_suggestion_card.dart';
import '../widgets/tracked_ai_summary_card.dart';

class TrackedAiView extends ConsumerWidget {
  const TrackedAiView({super.key, this.onSearch, this.onActivitySummary});

  final ValueChanged<String>? onSearch;
  final VoidCallback? onActivitySummary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedAiControllerProvider);

    return ListView(
      padding: AppInsets.all(24),
      children: [
        const TrackedAiHeader(),
        16.ph,
        TrackedAiSearchBar(
          controller: controller.queryController,
          onSubmit: () => controller.search(onSearch: onSearch),
        ),
        24.ph,
        TrackedAiSummaryCard(onTap: onActivitySummary),
        24.ph,
        Text(
          AppStrings.trackedAiSuggestedQueries.toUpperCase(),
          style: context.bodySmallStyle?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
            letterSpacing: 0.3,
            color: AppColors.primaryWhite,
          ),
        ),
        for (final query in controller.suggestions) ...[
          10.ph,
          TrackedAiSuggestionCard(
            query: query,
            onTap: () => controller.search(query: query, onSearch: onSearch),
          ),
        ],
      ],
    );
  }
}
