import '../../../../../core/utils/app_exports.dart';
import '../controller/auth_controller.dart';
import '../widgets/tracked_subscription_scaffold.dart';

class TrackedSubscriptionActiveView extends ConsumerWidget {
  const TrackedSubscriptionActiveView({super.key, this.onGetStarted});

  final VoidCallback? onGetStarted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(authControllerProvider).selectedPlan;

    return TrackedSubscriptionScaffold(
      child: Padding(
        padding: AppInsets.only(left: 24, right: 24, bottom: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 80.w,
                height: 80.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.trackedPlanFeatureIncluded
                      .withValues(alpha: 0.2),
                ),
                child: SvgPicture.asset(
                  AppAssetsSvg.trackedSubscriptionActiveIcon,
                  width: 40.w,
                  height: 40.w,
                ),
              ),
            ),
            16.ph,
            Text(
              AppStrings.trackedSubscriptionActiveTitle,
              textAlign: TextAlign.center,
              style: context.headlineSmallStyle?.copyWith(
                color: AppColors.primaryWhite,
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                height: 32 / 24,
              ),
            ),
            16.ph,
            Text(
              plan.name + AppStrings.trackedSubscriptionActivePlanSuffix,
              textAlign: TextAlign.center,
              style: context.bodyMediumStyle?.copyWith(
                color: AppColors.trackedPlanMutedText,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
              ),
            ),
            16.ph,
            Text(
              AppStrings.trackedSubscriptionActiveSubtitle,
              textAlign: TextAlign.center,
              style: context.bodySmallStyle?.copyWith(
                color: AppColors.trackedPlanFaintText,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 16 / 12,
              ),
            ),
            16.ph,
            PrimaryAppButton(
              text: AppStrings.trackedSubscriptionGetStarted,
              onTap: onGetStarted ?? () {},
            ),
          ],
        ),
      ),
    );
  }
}
