import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_scaffold.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../controller/tracker_profile_controller.dart';
import '../widgets/tracker_plan_widgets.dart';

/// The viewer's plan and what each tier includes, reached from the profile's
/// Plan & Subscription row.
class TrackerPlanSubscriptionView extends ConsumerWidget {
  const TrackerPlanSubscriptionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerProfileControllerProvider);

    return TrackerDetailScaffold(
      title: AppStrings.trackerPlanSubscription,
      subtitle: AppStrings.trackerPlanSubtitle,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerPlanBackTooltip,
      child: ListView(
        key: const PageStorageKey('tracker-plan-subscription'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          const TrackerPlanCard(),
          24.ph,
          Text(
            AppStrings.trackerPlanComparison,
            style: context.bodySmallStyle?.copyWith(
              fontSize: 12.sp,
              height: 16 / 12,
              fontWeight: FontWeight.w600,
              letterSpacing: .6,
              color: AppColors.trackerAlertSubtitle,
            ),
          ),
          10.ph,
          TrackerPlanComparisonTable(
            tiers: TrackerProfileController.planTiers,
            features: controller.planFeatures,
          ),
          24.ph,
          Container(
            width: double.infinity,
            padding: AppInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.trackerSurfaceFill,
              borderRadius: 16.circular,
              border: Border.all(color: AppColors.trackerSurfaceFill),
            ),
            child: Column(
              children: [
                const TrackerDetailText(AppStrings.trackerPlanFooterTitle,
                    weight: FontWeight.w500, height: 20 / 14),
                4.ph,
                Text(
                  AppStrings.trackerPlanFooterNote,
                  textAlign: TextAlign.center,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    height: 16 / 12,
                    color: AppColors.trackerAlertSubtitle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
