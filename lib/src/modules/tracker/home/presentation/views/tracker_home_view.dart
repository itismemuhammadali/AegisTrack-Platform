import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_alert_entity.dart';
import '../controller/tracker_home_controller.dart';
import '../widgets/tracker_alert_row.dart';
import '../widgets/tracker_home_header.dart';
import '../widgets/tracker_stats_grid.dart';
import '../widgets/tracker_user_card.dart';

class TrackerHomeView extends ConsumerWidget {
  const TrackerHomeView({
    super.key,
    this.onNotifications,
    this.onSosDetails,
    this.onMissingLogDetails,
    this.onViewAllUsers,
    this.onViewAllAlerts,
    this.onAlertSelected,
  });

  final VoidCallback? onNotifications;
  final VoidCallback? onSosDetails;
  final VoidCallback? onMissingLogDetails;
  final VoidCallback? onViewAllUsers;
  final VoidCallback? onViewAllAlerts;

  /// Tapping a recent alert card opens the alert centre.
  final ValueChanged<TrackerAlertEntity>? onAlertSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerHomeControllerProvider);

    return ListView(
      padding: EdgeInsets.fromLTRB(
          24.w, 24.h, 24.w, 24.h + MediaQuery.paddingOf(context).bottom),
      children: [
        TrackerHomeHeader(
          name: controller.viewerName,
          onNotifications: onNotifications,
        ),
        24.ph,
        TrackerEventBanner(
          title: controller.sosUserName,
          subtitle: AppStrings.trackerSosEvent,
          accent: AppColors.primaryRed,
          actionColor: AppColors.trackerSosRed,
          onTap: onSosDetails,
        ),
        24.ph,
        TrackerStatsGrid(
          trackedUsers: controller.trackedUsersStatus,
          activeAlerts: controller.activeAlerts,
          syncRate: controller.syncRate,
          missedCheckIns: controller.missedCheckIns,
        ),
        24.ph,
        _SectionHeader(
          title: AppStrings.trackerTrackedUsers,
          onViewAll: onViewAllUsers,
        ),
        for (final user in controller.users) ...[
          16.ph,
          TrackerUserCard(user: user),
        ],
        24.ph,
        TrackerEventBanner(
          title: AppStrings.trackerMissingLog,
          subtitle: controller.missingLogDetail,
          accent: AppColors.trackerAmber,
          actionColor: AppColors.trackerAmber,
          leading: Container(
            width: 40.w,
            height: 40.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.trackerAmber.withValues(alpha: 0.1),
            ),
            child: SvgPicture.asset(
              AppAssetsSvg.trackerMissingLog,
              width: 18.w,
              height: 18.w,
            ),
          ),
          onTap: onMissingLogDetails,
        ),
        24.ph,
        _SectionHeader(
          title: AppStrings.trackerRecentAlerts,
          onViewAll: onViewAllAlerts,
        ),
        for (final alert in controller.alerts) ...[
          16.ph,
          TrackerAlertRow(
            alert: alert,
            onTap:
                onAlertSelected == null ? null : () => onAlertSelected!(alert),
          ),
        ],
        24.ph,
        Row(
          children: [
            Expanded(
              child: _FooterButton(
                label: AppStrings.trackerViewAllAlerts,
                onTap: onViewAllAlerts,
              ),
            ),
            24.pw,
            Expanded(
              child: _FooterButton(
                label: AppStrings.trackerViewAllUsers,
                isPrimary: true,
                onTap: onViewAllUsers,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onViewAll});

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.titleMediumStyle?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            height: 28 / 18,
            color: AppColors.primaryWhite,
          ),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Text(
            AppStrings.trackerViewAll,
            style: context.bodyMediumStyle?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
              color: AppColors.primaryWhite.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterButton extends StatelessWidget {
  const _FooterButton({
    required this.label,
    this.isPrimary = false,
    this.onTap,
  });

  final String label;
  final bool isPrimary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              isPrimary ? null : AppColors.primaryWhite.withValues(alpha: 0.05),
          gradient: isPrimary
              ? const LinearGradient(
                  colors: AppColors.trackedQuickActionGradientColors,
                )
              : null,
          borderRadius: 26.circular,
          border: isPrimary
              ? null
              : Border.all(
                  color: AppColors.primaryWhite.withValues(alpha: 0.1),
                ),
        ),
        child: Text(
          label,
          style: context.bodyMediumStyle?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
            color: AppColors.primaryWhite,
          ),
        ),
      ),
    );
  }
}
