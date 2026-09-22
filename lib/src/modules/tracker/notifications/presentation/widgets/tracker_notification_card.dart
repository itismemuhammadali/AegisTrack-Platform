import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_notification_entity.dart';

class TrackerNotificationCard extends StatelessWidget {
  const TrackerNotificationCard({super.key, required this.alert, this.onTap});

  final TrackerNotificationEntity alert;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Tinted cards mute their supporting text; neutral ones keep it white.
    final isTinted = alert.kind.cardFill != null;
    final supportingColor =
        isTinted ? AppColors.trackerAlertSubtitle : AppColors.primaryWhite;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: alert.kind.cardFill ?? AppColors.trackerSurfaceFill,
          borderRadius: 16.circular,
          border: Border.all(
              color: alert.kind.cardBorder ?? AppColors.trackerBorderSoft),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppInsets.only(top: 2),
              child: _TrackerNotificationIcon(kind: alert.kind),
            ),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          alert.kind.label,
                          overflow: TextOverflow.ellipsis,
                          style: context.bodySmallStyle?.copyWith(
                            fontSize: 12.sp,
                            height: 16 / 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .3,
                            color: supportingColor,
                          ),
                        ),
                      ),
                      if (alert.isUnread) ...[
                        8.pw,
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.trackerAlertUnreadDot,
                          ),
                        ),
                      ],
                    ],
                  ),
                  2.ph,
                  Text(
                    alert.name,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      height: 20 / 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.viewerSignInText,
                    ),
                  ),
                  Text(
                    alert.detail,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      height: 16 / 12,
                      fontWeight: FontWeight.w400,
                      color: supportingColor,
                    ),
                  ),
                  4.ph,
                  Text(
                    alert.time,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      height: 16 / 12,
                      fontWeight: FontWeight.w400,
                      color: supportingColor,
                    ),
                  ),
                ],
              ),
            ),
            8.pw,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: alert.severity.fill,
                    borderRadius: 100.circular,
                  ),
                  child: Text(
                    alert.severity.label,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      height: 16 / 12,
                      fontWeight: FontWeight.w500,
                      color: alert.severity.color,
                    ),
                  ),
                ),
                8.ph,
                SvgPicture.asset(AppAssetsSvg.trackerAlertCenterChevron,
                    width: 16.w, height: 16.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackerNotificationIcon extends StatelessWidget {
  const _TrackerNotificationIcon({required this.kind});

  final TrackerNotificationKind kind;

  @override
  Widget build(BuildContext context) {
    final circle = Container(
      width: 40.w,
      height: 40.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: kind.iconFill),
      child: SvgPicture.asset(kind.icon, width: 20.w, height: 20.w),
    );
    if (!kind.hasGlow) return circle;
    return Container(
      width: 40.w,
      height: 40.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.trackerDangerRed.withValues(alpha: .14),
            blurRadius: 16.w,
            spreadRadius: 10.w,
          ),
        ],
      ),
      child: circle,
    );
  }
}
