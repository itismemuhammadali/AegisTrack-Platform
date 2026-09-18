import '../../../../../core/utils/app_exports.dart';
import '../controller/auth_controller.dart';
import '../widgets/tracked_subscription_scaffold.dart';

class TrackedConfirmSubscriptionView extends ConsumerWidget {
  const TrackedConfirmSubscriptionView({
    super.key,
    this.onConfirmed,
    this.onAddCard,
  });

  final VoidCallback? onConfirmed;
  final VoidCallback? onAddCard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(authControllerProvider);
    final plan = controller.selectedPlan;

    final mutedStyle = context.bodyMediumStyle?.copyWith(
      color: AppColors.trackedPlanMutedText,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      height: 20 / 14,
    );
    final valueStyle = mutedStyle?.copyWith(color: AppColors.primaryWhite);

    return TrackedSubscriptionScaffold(
      title: AppStrings.trackedConfirmSubscriptionTitle,
      subtitle: AppStrings.trackedConfirmSubscriptionSubtitle,
      child: Padding(
        padding: AppInsets.only(left: 24, right: 24, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TrackedSubscriptionCard(
                      label: AppStrings.trackedConfirmSelectedPlan,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plan.name,
                                  style: context.titleMediumStyle?.copyWith(
                                    color: AppColors.primaryWhite,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    height: 28 / 18,
                                  ),
                                ),
                                Text(
                                  plan.period,
                                  style: mutedStyle?.copyWith(
                                    color: AppColors.trackedPlanFaintText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            plan.price,
                            style: context.headlineSmallStyle?.copyWith(
                              color: AppColors.primaryWhite,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              height: 32 / 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.ph,
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: onAddCard,
                        child: Text(
                          AppStrings.trackedConfirmAddCard,
                          style: context.bodyLargeStyle?.copyWith(
                            color: AppColors.primaryWhite,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            height: 20 / 17,
                          ),
                        ),
                      ),
                    ),
                    16.ph,
                    TrackedSubscriptionCard(
                      label: AppStrings.trackedConfirmPaymentMethod,
                      child: Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryWhite.withValues(alpha: 0.1),
                              borderRadius: 18.circular,
                            ),
                            child: SvgPicture.asset(
                              AppAssetsSvg.trackedSubscriptionCardIcon,
                              width: 20.w,
                              height: 20.w,
                            ),
                          ),
                          12.pw,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.trackedConfirmCardTitle,
                                  style: valueStyle?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  AppStrings.trackedConfirmCardExpiry,
                                  style: context.bodySmallStyle?.copyWith(
                                    color: AppColors.trackedPlanFaintText,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 16 / 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.ph,
                    TrackedSubscriptionCard(
                      label: AppStrings.trackedConfirmBillingSummary,
                      child: Column(
                        children: [
                          _SummaryRow(
                            label:
                                plan.name + AppStrings.trackedConfirmPlanSuffix,
                            value: plan.price,
                            labelStyle: mutedStyle,
                            valueStyle: valueStyle,
                          ),
                          10.ph,
                          _SummaryRow(
                            label: AppStrings.trackedConfirmTax,
                            value: AppStrings.trackedConfirmTaxAmount,
                            labelStyle: mutedStyle,
                            valueStyle: valueStyle,
                          ),
                          10.ph,
                          Container(
                            padding: AppInsets.only(top: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: AppColors.primaryWhite
                                      .withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                            child: _SummaryRow(
                              label: AppStrings.trackedConfirmTotalToday,
                              value: plan.price,
                              labelStyle: valueStyle?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              valueStyle: valueStyle?.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                height: 24 / 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    32.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppAssetsSvg.trackedSubscriptionLockIcon,
                          width: 14.w,
                          height: 14.w,
                        ),
                        8.pw,
                        Text(
                          AppStrings.trackedConfirmStripeNotice,
                          style: context.bodySmallStyle?.copyWith(
                            color: AppColors.trackedPlanFaintText,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            height: 16 / 12,
                          ),
                        ),
                      ],
                    ),
                    16.ph,
                  ],
                ),
              ),
            ),
            PrimaryAppButton(
              text: AppStrings.trackedConfirmSubscriptionTitle,
              leading: SvgPicture.asset(
                AppAssetsSvg.trackedSubscriptionShieldIcon,
                width: 20.w,
                height: 20.w,
              ),
              isLoading: controller.isConfirmingSubscription,
              onTap: () =>
                  controller.confirmSubscription(onSuccess: onConfirmed),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}
