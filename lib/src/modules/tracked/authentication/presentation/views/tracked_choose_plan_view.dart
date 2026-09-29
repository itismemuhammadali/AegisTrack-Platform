import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracked_subscription_plan_entity.dart';
import '../controller/auth_controller.dart';
import '../widgets/tracked_plan_card.dart';
import '../widgets/tracked_subscription_scaffold.dart';

class TrackedChoosePlanView extends ConsumerWidget {
  const TrackedChoosePlanView({super.key, this.onContinue});

  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(authControllerProvider);

    return TrackedSubscriptionScaffold(
      title: AppStrings.trackedChoosePlanTitle,
      subtitle: AppStrings.trackedChoosePlanSubtitle,
      child: SingleChildScrollView(
        padding: AppInsets.only(left: 24, right: 24, top: 8, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final plan in TrackedSubscriptionPlan.values) ...[
              TrackedPlanCard(
                plan: plan,
                isSelected: controller.selectedPlan == plan,
                onTap: () => controller.selectPlan(plan),
              ),
              16.ph,
            ],
            PrimaryAppButton(
              text: AppStrings.trackedChoosePlanContinuePrefix +
                  controller.selectedPlan.name,
              onTap: onContinue ?? () {},
            ),
            16.ph,
            Text(
              AppStrings.trackedChoosePlanFootnote,
              textAlign: TextAlign.center,
              style: context.bodySmallStyle?.copyWith(
                color: AppColors.primaryWhite.withValues(alpha: 0.6),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 16 / 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
