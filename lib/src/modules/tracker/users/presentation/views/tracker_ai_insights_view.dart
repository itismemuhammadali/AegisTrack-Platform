import '../../../../../core/utils/app_exports.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';
import '../controller/tracker_users_controller.dart';
import '../widgets/tracker_ai_summary_card.dart';
import '../widgets/tracker_detail_scaffold.dart';

/// Asks for an AI summary of a user over a chosen date range, reached from the
/// AI Insights quick action.
class TrackerAiInsightsView extends ConsumerWidget {
  const TrackerAiInsightsView({super.key, this.user, this.onGenerate});

  final TrackerUserEntity? user;

  /// Receives the range the viewer picked.
  final ValueChanged<String>? onGenerate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerUsersControllerProvider);

    return TrackerDetailScaffold(
      title: AppStrings.trackerActionAiInsights,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerAiInsightsBackTooltip,
      child: ListView(
        key: const PageStorageKey('tracker-ai-insights'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          TrackerAiSummaryCard(
            initials: user == null ? '' : controller.initials(user!),
            name: user?.name ?? '',
            ranges: TrackerUsersController.aiDateRanges,
            selectedRange: controller.aiDateRange,
            onRangeSelected: controller.setAiDateRange,
            onGenerate: onGenerate == null
                ? null
                : () => onGenerate!(controller.aiDateRange),
          ),
        ],
      ),
    );
  }
}
