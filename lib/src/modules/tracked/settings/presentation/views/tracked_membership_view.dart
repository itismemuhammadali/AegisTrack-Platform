import '../../../../../core/utils/app_exports.dart';
import '../../../authentication/domain/entities/tracked_subscription_plan_entity.dart';
import '../../../authentication/presentation/widgets/tracked_subscription_scaffold.dart';
import '../../domain/entities/tracked_payment_card_entity.dart';
import '../controller/tracked_settings_controller.dart';
import '../widgets/tracked_membership_current_plan_card.dart';
import '../widgets/tracked_membership_payment_card_row.dart';
import '../widgets/tracked_membership_plan_row.dart';
import '../widgets/tracked_membership_sheets.dart';

class TrackedMembershipView extends ConsumerWidget {
  const TrackedMembershipView({super.key, this.onCancelSubscription});

  final VoidCallback? onCancelSubscription;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedSettingsControllerProvider);
    final sectionStyle = context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
      letterSpacing: 0.3,
      color: AppColors.primaryWhite,
    );

    void changePlan(TrackedSubscriptionPlan plan) {
      final isUpgrade = plan.index > controller.currentPlan.index;
      final price = plan == TrackedSubscriptionPlan.free
          ? plan.price
          : plan.price + AppStrings.trackedMembershipPerMonth;
      showTrackedMembershipSheet<void>(
        context,
        child: TrackedMembershipConfirmSheet(
          icon: isUpgrade
              ? AppAssetsSvg.trackedMembershipUpgradeAlert
              : AppAssetsSvg.trackedMembershipDowngradeAlert,
          accent: isUpgrade
              ? AppColors.trackedZoneAllowedGreen
              : AppColors.trackedCheckInAmber,
          title: isUpgrade
              ? AppStrings.trackedMembershipUpgradePlan
              : AppStrings.trackedMembershipDowngradePlan,
          subtitle: TextSpan(
            children: [
              const TextSpan(text: AppStrings.trackedMembershipSwitchTo),
              TextSpan(
                text: plan.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryWhite,
                ),
              ),
              TextSpan(text: ' · $price'),
            ],
          ),
          description: isUpgrade
              ? AppStrings.trackedMembershipUpgradeDescription
              : AppStrings.trackedMembershipDowngradeDescription,
          descriptionColor: isUpgrade
              ? AppColors.primaryWhite.withValues(alpha: 0.6)
              : AppColors.hintGray,
          confirmLabel: isUpgrade
              ? AppStrings.trackedMembershipConfirmUpgrade
              : AppStrings.trackedMembershipConfirmChange,
          confirmGradient: isUpgrade
              ? const LinearGradient(
                  colors: AppColors.trackedQuickActionGradientColors,
                )
              : null,
          onConfirm: () => controller.changePlan(plan),
        ),
      );
    }

    void removeCard(TrackedPaymentCardEntity card) {
      showTrackedMembershipSheet<void>(
        context,
        child: TrackedMembershipConfirmSheet(
          icon: AppAssetsSvg.trackedMembershipRemoveCard,
          accent: AppColors.trackedSosRed,
          title: AppStrings.trackedMembershipRemoveCard,
          subtitle: TextSpan(text: card.maskedNumber),
          description: AppStrings.trackedMembershipRemoveCardDescription,
          confirmLabel: AppStrings.trackedMembershipRemove,
          onConfirm: () => controller.removeCard(card),
        ),
      );
    }

    void addCard() {
      showTrackedMembershipSheet<void>(
        context,
        child: TrackedAddCardSheet(
          onAdd: (number, expiry) =>
              controller.addCard(number: number, expiry: expiry),
        ),
      );
    }

    return TrackedSubscriptionScaffold(
      title: AppStrings.trackedMembershipTitle,
      subtitle: AppStrings.trackedMembershipSubtitle,
      child: ListView(
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          Text(
            AppStrings.trackedMembershipCurrentPlan.toUpperCase(),
            style: sectionStyle,
          ),
          10.ph,
          TrackedMembershipCurrentPlanCard(plan: controller.currentPlan),
          24.ph,
          Text(
            AppStrings.trackedMembershipChangePlan.toUpperCase(),
            style: sectionStyle,
          ),
          for (final plan in TrackedSubscriptionPlan.values) ...[
            10.ph,
            TrackedMembershipPlanRow(
              plan: plan,
              currentPlan: controller.currentPlan,
              onTap: () => changePlan(plan),
            ),
          ],
          16.ph,
          Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.trackedMembershipPaymentMethods.toUpperCase(),
                  style: sectionStyle,
                ),
              ),
              GestureDetector(
                onTap: addCard,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppAssetsSvg.trackedMembershipAdd,
                      width: 14.w,
                      height: 14.w,
                    ),
                    4.pw,
                    Text(
                      AppStrings.trackedConfirmAddCard,
                      style: sectionStyle?.copyWith(letterSpacing: 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          for (final card in controller.paymentCards) ...[
            10.ph,
            TrackedMembershipPaymentCardRow(
              card: card,
              onSetDefault: () => controller.setDefaultCard(card),
              onDelete: () => removeCard(card),
            ),
          ],
          24.ph,
          GestureDetector(
            onTap: onCancelSubscription,
            child: Container(
              padding: AppInsets.all(16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryWhite.withValues(alpha: 0.05),
                borderRadius: 16.circular,
                border: Border.all(
                  color: AppColors.primaryWhite.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                AppStrings.trackedMembershipCancelSubscription,
                style: context.bodyMediumStyle?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 20 / 14,
                  color: AppColors.trackedSosRed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
