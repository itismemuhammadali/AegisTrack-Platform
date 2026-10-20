import '../../../../../core/utils/app_exports.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';
import '../../domain/entities/tracker_check_in_entity.dart';
import '../controller/tracker_users_controller.dart';
import '../widgets/tracker_check_in_card.dart';
import '../widgets/tracker_check_ins_stats_row.dart';
import '../widgets/tracker_detail_scaffold.dart';
import '../widgets/tracker_timeline_filter_bar.dart';

/// Read-only check-in schedule reached from a user's Check-ins quick action.
class TrackerCheckInsView extends ConsumerWidget {
  const TrackerCheckInsView({super.key, this.user, this.onCheckInSelected});

  final TrackerUserEntity? user;
  final ValueChanged<TrackerCheckInEntity>? onCheckInSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerUsersControllerProvider);
    final checkIns = controller.visibleCheckIns;
    final title = user == null
        ? AppStrings.trackerCheckIns
        : '${AppStrings.trackerCheckIns} · ${user!.name}';

    return TrackerDetailScaffold(
      title: title,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerBackToUserDetails,
      child: ListView(
        key: const PageStorageKey('tracker-check-ins'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          TrackerCheckInsStatsRow(
            completed: controller.completedCheckIns,
            missed: controller.missedCheckInsCount,
            upcoming: controller.upcomingCheckIns,
          ),
          24.ph,
          TrackerTimelineFilterBar(
            filters: TrackerUsersController.checkInFilters,
            selected: controller.checkInFilter,
            onSelected: controller.setCheckInFilter,
            radius: 16,
          ),
          24.ph,
          if (checkIns.isEmpty)
            Padding(
              padding: AppInsets.all(24),
              child: Text(
                AppStrings.trackerCheckInsEmpty,
                textAlign: TextAlign.center,
                style: context.bodyMediumStyle
                    ?.copyWith(color: AppColors.trackerMutedText),
              ),
            ),
          for (final checkIn in checkIns) ...[
            TrackerCheckInCard(
              checkIn: checkIn,
              onTap: onCheckInSelected == null
                  ? null
                  : () => onCheckInSelected!(checkIn),
            ),
            10.ph,
          ],
        ],
      ),
    );
  }
}
