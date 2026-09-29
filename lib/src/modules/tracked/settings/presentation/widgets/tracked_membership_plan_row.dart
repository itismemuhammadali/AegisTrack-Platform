import '../../../../../core/utils/app_exports.dart';
import '../../../authentication/domain/entities/tracked_subscription_plan_entity.dart';

class TrackedMembershipPlanRow extends StatelessWidget {
  const TrackedMembershipPlanRow({
    super.key,
    required this.plan,
    required this.currentPlan,
    this.onTap,
  });

  final TrackedSubscriptionPlan plan;
  final TrackedSubscriptionPlan currentPlan;
  final VoidCallback? onTap;

  bool get _isCurrent => plan == currentPlan;
  bool get _isUpgrade => plan.index > currentPlan.index;

  String get _icon => plan == TrackedSubscriptionPlan.free
      ? AppAssetsSvg.trackedMembershipFreeIcon
      : plan.icon;

  /// Free uses a neutral 10% white tile here (Figma), unlike the plan picker.
  Color get _iconBackground => plan == TrackedSubscriptionPlan.free
      ? AppColors.primaryWhite.withValues(alpha: 0.1)
      : plan.iconBackground;

  String get _subtitle => plan == TrackedSubscriptionPlan.free
      ? AppStrings.trackedMembershipFreeForever
      : plan.price + AppStrings.trackedMembershipPerMonth;

  @override
  Widget build(BuildContext context) {
    final actionColor = _isUpgrade
        ? AppColors.trackedZoneAllowedGreen
        : AppColors.trackedCheckInAmber;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _isCurrent ? null : onTap,
      child: Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite.withValues(
            alpha: _isCurrent ? 0.08 : 0.05,
          ),
          borderRadius: 16.circular,
          border: Border.all(
            color: AppColors.primaryWhite.withValues(
              alpha: _isCurrent ? 0.2 : 0.1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _iconBackground,
                borderRadius: 18.circular,
              ),
              child: SvgPicture.asset(_icon, width: 20.w, height: 20.w),
            ),
            16.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      height: 20 / 14,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                  Text(
                    _subtitle,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      height: 16 / 12,
                      color: AppColors.hintGray,
                    ),
                  ),
                ],
              ),
            ),
            if (_isCurrent)
              SvgPicture.asset(
                AppAssetsSvg.trackedMembershipCurrentCheck,
                width: 14.w,
                height: 14.w,
              )
            else ...[
              Text(
                _isUpgrade
                    ? AppStrings.trackedMembershipUpgrade
                    : AppStrings.trackedMembershipDowngrade,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  height: 16 / 12,
                  color: actionColor,
                ),
              ),
              4.pw,
              SvgPicture.asset(
                _isUpgrade
                    ? AppAssetsSvg.trackedMembershipUpgradeChevron
                    : AppAssetsSvg.trackedMembershipDowngradeChevron,
                width: 14.w,
                height: 14.w,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
