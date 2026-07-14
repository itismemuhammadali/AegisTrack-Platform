import '../../../../../core/utils/app_exports.dart';

class TrackedSettingsProfileCard extends StatelessWidget {
  const TrackedSettingsProfileCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite.withValues(alpha: 0.05),
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackedSettingsCardBorder),
        ),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                AppAssetsPng.trackedSettingsProfileAvatar,
                width: 48.w,
                height: 48.w,
                fit: BoxFit.cover,
              ),
            ),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.trackedSettingsProfileName,
                    style: context.bodyLargeStyle?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                  6.ph,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.trackedTrackingActiveGreen
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      8.pw,
                      Text(
                        AppStrings.trackingActive,
                        style: context.bodySmallStyle?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.trackedTrackingActiveGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AppAssetsSvg.trackedSettingsChevronIcon,
              width: 20.sp,
              height: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
