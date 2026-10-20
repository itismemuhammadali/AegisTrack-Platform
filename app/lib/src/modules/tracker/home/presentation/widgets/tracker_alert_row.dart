import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_alert_entity.dart';

class TrackerAlertRow extends StatelessWidget {
  const TrackerAlertRow({super.key, required this.alert, this.onTap});

  final TrackerAlertEntity alert;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite.withValues(alpha: 0.05),
          borderRadius: 24.circular,
          border: Border.all(
            color: AppColors.primaryWhite.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: alert.color.withValues(alpha: 0.05),
              ),
              child: SvgPicture.asset(alert.icon, width: 16.w, height: 16.w),
            ),
            10.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.title,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 20 / 14,
                      color: AppColors.viewerSignInText,
                    ),
                  ),
                  Text(
                    alert.subtitle,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      height: 16 / 12,
                      color: AppColors.trackerAlertSubtitle,
                    ),
                  ),
                ],
              ),
            ),
            8.pw,
            Text(
              alert.time,
              style: context.bodySmallStyle?.copyWith(
                fontSize: 12.sp,
                height: 16 / 12,
                color: AppColors.primaryWhite.withValues(alpha: 0.6),
              ),
            ),
            10.pw,
            SvgPicture.asset(
              AppAssetsSvg.trackerAlertChevron,
              width: 16.w,
              height: 16.w,
            ),
          ],
        ),
      ),
    );
  }
}
