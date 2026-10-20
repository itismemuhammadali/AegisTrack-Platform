import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_scaffold.dart';
import '../../../users/presentation/widgets/tracker_timeline_filter_bar.dart';
import '../../domain/entities/tracker_notification_entity.dart';
import '../controller/tracker_notifications_controller.dart';
import '../widgets/tracker_notification_card.dart';

/// Alert centre, reached from every notification bell, the home alert cards
/// and a user's View Alerts quick action.
class TrackerNotificationsView extends ConsumerWidget {
  const TrackerNotificationsView({super.key, this.onAlertSelected});

  final ValueChanged<TrackerNotificationEntity>? onAlertSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerNotificationsControllerProvider);
    final groups = controller.visibleGroups;

    return TrackerDetailScaffold(
      title: AppStrings.trackerAlerts,
      subtitle: AppStrings.trackerAlertCenter,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerAlerts,
      trailing: Container(
        padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.trackerAlertCriticalRed,
          borderRadius: 100.circular,
        ),
        child: Text(
          '${controller.unreadCount} ${AppStrings.trackerUnreadSuffix}',
          style: context.bodySmallStyle?.copyWith(
            fontSize: 12.sp,
            height: 16 / 12,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryWhite,
          ),
        ),
      ),
      child: ListView(
        key: const PageStorageKey('tracker-notifications'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          TrackerTimelineFilterBar(
            filters: TrackerNotificationsController.filters,
            selected: controller.filter,
            onSelected: controller.setFilter,
          ),
          24.ph,
          if (groups.isEmpty)
            Padding(
              padding: AppInsets.all(24),
              child: Text(
                AppStrings.trackerAlertsEmpty,
                textAlign: TextAlign.center,
                style: context.bodyMediumStyle
                    ?.copyWith(color: AppColors.trackerMutedText),
              ),
            ),
          for (final group in groups) ...[
            Text(
              group.title.toUpperCase(),
              style: context.bodySmallStyle?.copyWith(
                fontSize: 12.sp,
                height: 16 / 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: AppColors.primaryWhite,
              ),
            ),
            10.ph,
            for (final alert in group.alerts) ...[
              TrackerNotificationCard(
                alert: alert,
                onTap: onAlertSelected == null
                    ? null
                    : () => onAlertSelected!(alert),
              ),
              6.ph,
            ],
            18.ph,
          ],
        ],
      ),
    );
  }
}
