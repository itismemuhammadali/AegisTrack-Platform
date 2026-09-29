import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracked_payment_card_entity.dart';

class TrackedMembershipPaymentCardRow extends StatelessWidget {
  const TrackedMembershipPaymentCardRow({
    super.key,
    required this.card,
    this.onSetDefault,
    this.onDelete,
  });

  final TrackedPaymentCardEntity card;
  final VoidCallback? onSetDefault;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isDefault = card.isDefault;

    return Container(
      padding: AppInsets.all(16),
      decoration: BoxDecoration(
        color:
            AppColors.primaryWhite.withValues(alpha: isDefault ? 0.08 : 0.05),
        borderRadius: 16.circular,
        border: Border.all(
          color:
              AppColors.primaryWhite.withValues(alpha: isDefault ? 0.2 : 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryWhite.withValues(alpha: 0.1),
              borderRadius: 18.circular,
            ),
            child: SvgPicture.asset(
              AppAssetsSvg.trackedSubscriptionCardIcon,
              width: 20.w,
              height: 20.w,
            ),
          ),
          16.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        card.maskedNumber,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodyMediumStyle?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 20 / 14,
                          color: AppColors.primaryWhite,
                        ),
                      ),
                    ),
                    if (isDefault) ...[
                      8.pw,
                      Container(
                        padding:
                            AppInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.twoFactorAccentPurple
                              .withValues(alpha: 0.4),
                          borderRadius: 4.circular,
                        ),
                        child: Text(
                          AppStrings.trackedMembershipDefault.toUpperCase(),
                          style: context.labelSmallStyle?.copyWith(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                            height: 13.5 / 9,
                            color: AppColors.signInDarkSubtitle,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (isDefault) 4.ph,
                Text(
                  AppStrings.trackedMembershipExpires + card.expiry,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    height: 16 / 12,
                    color: AppColors.hintGray,
                  ),
                ),
              ],
            ),
          ),
          if (!isDefault) ...[
            GestureDetector(
              onTap: onSetDefault,
              child: Text(
                AppStrings.trackedMembershipSetDefault,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  height: 16 / 12,
                  color: AppColors.signInDarkSubtitle,
                ),
              ),
            ),
            8.pw,
          ],
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 32.w,
              height: 32.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.trackedSosRed.withValues(alpha: 0.1),
                borderRadius: 14.circular,
              ),
              child: SvgPicture.asset(
                AppAssetsSvg.trackedMembershipDelete,
                width: 14.w,
                height: 14.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
