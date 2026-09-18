import '../../../../../core/utils/app_exports.dart';
import '../controller/tracked_ai_controller.dart';
import '../widgets/tracked_ai_header.dart';
import '../widgets/tracked_ai_result_card.dart';
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

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: AppInsets.only(left: 24, right: 24, top: 24),
          sliver: SliverList.list(
            children: [
              TrackedAiHeader(
                onBack: controller.isIdle ? null : controller.reset,
              ),
              controller.isIdle ? 16.ph : 10.ph,
              TrackedAiSearchBar(
                controller: controller.queryController,
                isActive: !controller.isIdle,
                onSubmit: () => controller.search(onSearch: onSearch),
              ),
              24.ph,
              TrackedAiSummaryCard(onTap: onActivitySummary),
              24.ph,
            ],
          ),
        ),
        SliverPadding(
          padding: AppInsets.only(left: 24, right: 24, bottom: 24),
          sliver: switch (controller.state) {
            TrackedAiSearchState.idle => _Suggestions(
                controller: controller,
                onSearch: onSearch,
              ),
            TrackedAiSearchState.searching => const SliverFillRemaining(
                hasScrollBody: false,
                child: _Analyzing(),
              ),
            TrackedAiSearchState.results => _Results(controller: controller),
          },
        ),
      ],
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.controller, this.onSearch});

  final TrackedAiController controller;
  final ValueChanged<String>? onSearch;

  @override
  Widget build(BuildContext context) {
    return SliverList.list(
      children: [
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

class _Analyzing extends StatelessWidget {
  const _Analyzing();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 40.w,
          height: 40.w,
          child: CircularProgressIndicator(
            strokeWidth: 1.06,
            color: AppColors.primaryWhite.withValues(alpha: 0.3),
          ),
        ),
        16.ph,
        Text(
          AppStrings.trackedAiAnalyzing,
          style: context.bodyMediumStyle?.copyWith(
            fontSize: 14.sp,
            height: 20 / 14,
            color: AppColors.signInDarkSubtitle,
          ),
        ),
      ],
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.controller});

  final TrackedAiController controller;

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
    );

    return SliverList.list(
      children: [
        Row(
          children: [
            Text(
              AppStrings.trackedAiResultsFor.toUpperCase(),
              style: labelStyle?.copyWith(
                color: AppColors.hintGray,
                letterSpacing: 0.3,
              ),
            ),
            8.pw,
            Expanded(
              child: Text(
                '"${controller.submittedQuery}"',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: labelStyle?.copyWith(color: AppColors.primaryWhite),
              ),
            ),
          ],
        ),
        for (final result in controller.results) ...[
          16.ph,
          TrackedAiResultCard(result: result),
        ],
      ],
    );
  }
}
