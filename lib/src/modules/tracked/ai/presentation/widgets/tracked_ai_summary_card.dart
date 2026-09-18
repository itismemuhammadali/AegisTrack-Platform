import '../../../../../core/utils/app_exports.dart';

class TrackedAiSummaryCard extends StatelessWidget {
  const TrackedAiSummaryCard({super.key, this.onTap});

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
          borderRadius: 16.circular,
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryWhite.withValues(alpha: 0.1),
                borderRadius: 10.circular,
              ),
              child: SvgPicture.asset(
                AppAssetsSvg.trackedAiSummaryIcon,
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
                    AppStrings.trackedAiSummaryTitle,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 20 / 14,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                  Text(
                    AppStrings.trackedAiSummarySubtitle,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      height: 16 / 12,
                      color: AppColors.signInDarkSubtitle,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AppAssetsSvg.trackedAiChevron,
              width: 20.w,
              height: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
