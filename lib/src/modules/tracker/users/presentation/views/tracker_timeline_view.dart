import '../../../../../core/utils/app_exports.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';
import '../widgets/tracker_detail_scaffold.dart';
import '../widgets/tracker_security_footer_button.dart';
import '../../domain/entities/tracker_timeline_log_entity.dart';
import '../controller/tracker_timeline_controller.dart';
import '../widgets/tracker_timeline_filter_bar.dart';
import '../widgets/tracker_timeline_group_header.dart';
import '../widgets/tracker_timeline_log_card.dart';
import '../widgets/tracker_timeline_search_field.dart';
import '../widgets/tracker_timeline_stats_row.dart';

/// Read-only log history reached from a user's Timeline quick action.
class TrackerTimelineView extends ConsumerWidget {
  const TrackerTimelineView({
    super.key,
    this.user,
    this.onLogSelected,
    this.onViewAllOnMap,
  });

  final TrackerUserEntity? user;
  final ValueChanged<TrackerTimelineLogEntity>? onLogSelected;
  final VoidCallback? onViewAllOnMap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerTimelineControllerProvider);
    final groups = controller.visibleGroups;

    return TrackerDetailScaffold(
      title: AppStrings.trackerTimeline,
      subtitle: AppStrings.trackerTimelineSubtitle,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerBackToUserDetails,
      child: ListView(
        key: const PageStorageKey('tracker-timeline'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          TrackerTimelineSearchField(onChanged: controller.setQuery),
          10.ph,
          TrackerTimelineFilterBar(
            filters: TrackerTimelineController.filters,
            selected: controller.filter,
            onSelected: controller.setFilter,
          ),
          24.ph,
          TrackerTimelineStatsRow(
            total: controller.totalLogs,
            verified: controller.verifiedLogs,
            flagged: controller.flaggedLogs,
          ),
          24.ph,
          if (groups.isEmpty)
            Padding(
              padding: AppInsets.all(24),
              child: Text(
                AppStrings.trackerTimelineEmpty,
                textAlign: TextAlign.center,
                style: context.bodyMediumStyle
                    ?.copyWith(color: AppColors.trackerMutedText),
              ),
            ),
          for (final group in groups) ...[
            TrackerTimelineGroupHeader(
                title: group.title, count: group.logs.length),
            10.ph,
            for (final log in group.logs) ...[
              TrackerTimelineLogCard(
                log: log,
                onTap: onLogSelected == null ? null : () => onLogSelected!(log),
              ),
              10.ph,
            ],
            14.ph,
          ],
          TrackerSecurityFooterButton(
            AppStrings.trackerViewAllOnMap,
            icon: AppAssetsSvg.trackerTimelineMap,
            onTap: onViewAllOnMap,
          ),
        ],
      ),
    );
  }
}
