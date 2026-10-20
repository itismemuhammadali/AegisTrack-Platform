import '../../../../../core/utils/app_exports.dart';
import '../../../authentication/domain/entities/tracked_subscription_plan_entity.dart';

class TrackedMembershipCurrentPlanCard extends StatelessWidget {
  const TrackedMembershipCurrentPlanCard({super.key, required this.plan});

  final TrackedSubscriptionPlan plan;

  @override
  Widget build(BuildContext context) {
    const accent = AppColors.trackedPlanBasicAccent;
    final captionStyle = context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      height: 16 / 12,
    );

    return Container(
      width: double.infinity,
      padding: AppInsets.all(20),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.06),
        borderRadius: 16.circular,
        border: Border.all(color: accent.withValues(alpha: 0.19)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          plan.name,
                          style: context.titleLargeStyle?.copyWith(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            height: 28 / 20,
                            color: AppColors.primaryWhite,
                          ),
                        ),
                        8.pw,
                        Container(
                          padding: AppInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.13),
                            borderRadius: 100.circular,
                          ),
                          child: Text(
                            AppStrings.trackedMembershipActive,
                            style: captionStyle?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    2.ph,
                    Text(
                      plan.price + AppStrings.trackedMembershipPerMonthShort,
                      style: context.bodyMediumStyle?.copyWith(
                        fontSize: 14.sp,
                        height: 20 / 14,
                        color: AppColors.signInDarkSubtitle,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 48.w,
                height: 48.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.13),
                  borderRadius: 16.circular,
                ),
                child: SvgPicture.asset(
                  AppAssetsSvg.trackedMembershipCurrentStar,
                  width: 24.w,
                  height: 24.w,
                ),
              ),
            ],
          ),
          12.ph,
          Text.rich(
            TextSpan(
              text: AppStrings.trackedMembershipNextBilling,
              style: captionStyle?.copyWith(color: AppColors.hintGray),
              children: [
                TextSpan(
                  text: AppStrings.trackedMembershipNextBillingDate,
                  style: captionStyle?.copyWith(
                    color: AppColors.signInDarkSubtitle,
                  ),
                ),
              ],
            ),
          ),
          12.ph,
          Wrap(
            spacing: 6.w,
            runSpacing: 6.w,
            children: [
              for (final feature in AppStrings.trackedMembershipCurrentFeatures)
                Container(
                  padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite.withValues(alpha: 0.05),
                    borderRadius: 100.circular,
                    border: Border.all(
                      color: AppColors.primaryWhite.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Text(
                    feature,
                    style: context.labelSmallStyle?.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      height: 15 / 10,
                      color: AppColors.signInDarkSubtitle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
