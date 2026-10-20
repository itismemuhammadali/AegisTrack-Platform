import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracked_ai_result_entity.dart';

class TrackedAiResultCard extends StatelessWidget {
  const TrackedAiResultCard({super.key, required this.result, this.onTap});

  final TrackedAiResultEntity result;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final captionStyle = context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      height: 16 / 12,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite.withValues(alpha: 0.05),
          borderRadius: 16.circular,
          border: Border.all(
            color: AppColors.primaryWhite.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: result.iconBackground,
                borderRadius: 18.circular,
              ),
              child: SvgPicture.asset(result.icon, width: 16.w, height: 16.w),
            ),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 20 / 14,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                  2.ph,
                  Text(
                    result.subtitle,
                    style: captionStyle?.copyWith(
                      color: AppColors.signInDarkSubtitle,
                    ),
                  ),
                  4.ph,
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssetsSvg.trackedAiResultCalendar,
                        width: 12.w,
                        height: 12.w,
                      ),
                      4.pw,
                      Text(
                        result.timestamp,
                        style: captionStyle?.copyWith(
                          color: AppColors.hintGray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
