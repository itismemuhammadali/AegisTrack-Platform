import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracked_subscription_plan_entity.dart';

class TrackedPlanCard extends StatelessWidget {
  const TrackedPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  final TrackedSubscriptionPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: AppInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 16.circular,
        border: Border.all(
          color: AppColors.primaryWhite.withValues(
            alpha: isSelected ? 0.3 : 0.1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: plan.iconBackground,
                  borderRadius: 18.circular,
                ),
                child: SvgPicture.asset(plan.icon, width: 20.w, height: 20.w),
              ),
              16.pw,
              Expanded(child: _PlanSummary(plan: plan)),
              Padding(
                padding: AppInsets.only(top: 4),
                child: _PlanRadio(isSelected: isSelected),
              ),
            ],
          ),
          if (isSelected) ...[
            16.ph,
            Container(
              padding: AppInsets.only(top: 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.primaryWhite.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Column(
                children: [
                  for (var i = 0;
                      i < TrackedSubscriptionPlan.features.length;
                      i++) ...[
                    if (i > 0) 10.ph,
                    _PlanFeatureRow(
                      label: TrackedSubscriptionPlan.features[i],
                      isIncluded: i < plan.includedFeatureCount,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: plan.isPopular
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                card,
                Positioned(
                  top: -8.h,
                  right: 36.w,
                  child: Container(
                    padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.trackedPlanSelectedAccent,
                      borderRadius: 100.circular,
                    ),
                    child: Text(
                      AppStrings.trackedPlanPopularBadge,
                      style: context.bodySmallStyle?.copyWith(
                        color: AppColors.primaryWhite,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        height: 16 / 12,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : card,
    );
  }
}

class _PlanSummary extends StatelessWidget {
  const _PlanSummary({required this.plan});

  final TrackedSubscriptionPlan plan;

  @override
  Widget build(BuildContext context) {
    final captionStyle = context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              plan.name,
              style: context.bodyLargeStyle?.copyWith(
                color: AppColors.primaryWhite,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                height: 24 / 16,
              ),
            ),
            6.pw,
            Flexible(
              child: Text(
                plan.tagline,
                overflow: TextOverflow.ellipsis,
                style: captionStyle?.copyWith(
                  color: AppColors.trackedPlanMutedText,
                ),
              ),
            ),
          ],
        ),
        2.ph,
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              plan.price,
              style: context.titleLargeStyle?.copyWith(
                color: AppColors.primaryWhite,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                height: 28 / 20,
              ),
            ),
            4.pw,
            Text(
              plan.period,
              style: captionStyle?.copyWith(
                color: AppColors.trackedPlanFaintText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PlanRadio extends StatelessWidget {
  const _PlanRadio({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.w,
      height: 20.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.trackedPlanSelectedAccent : null,
        border: Border.all(
          color: isSelected
              ? AppColors.trackedPlanSelectedAccent
              : AppColors.primaryWhite.withValues(alpha: 0.3),
        ),
      ),
      child: isSelected
          ? SvgPicture.asset(
              AppAssetsSvg.trackedPlanSelectedCheck,
              width: 12.w,
              height: 12.w,
            )
          : null,
    );
  }
}

class _PlanFeatureRow extends StatelessWidget {
  const _PlanFeatureRow({required this.label, required this.isIncluded});

  final String label;
  final bool isIncluded;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16.w,
          height: 16.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isIncluded
                ? AppColors.trackedPlanFeatureIncluded.withValues(alpha: 0.2)
                : AppColors.primaryWhite.withValues(alpha: 0.05),
          ),
          child: isIncluded
              ? SvgPicture.asset(
                  AppAssetsSvg.trackedPlanFeatureCheck,
                  width: 10.w,
                  height: 10.w,
                )
              : Container(
                  width: 6.w,
                  height: 2.h,
                  decoration: BoxDecoration(
                    color: AppColors.trackedPlanFaintText,
                    borderRadius: 4.circular,
                  ),
                ),
        ),
        8.pw,
        Text(
          label,
          style: context.bodySmallStyle?.copyWith(
            color: isIncluded
                ? AppColors.trackedPlanMutedText
                : AppColors.trackedPlanFaintText,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
          ),
        ),
      ],
    );
  }
}
