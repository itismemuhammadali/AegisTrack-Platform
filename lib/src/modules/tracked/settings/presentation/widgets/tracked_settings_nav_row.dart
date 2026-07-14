import '../../../../../core/utils/app_exports.dart';

class TrackedSettingsNavRow extends StatelessWidget {
  const TrackedSettingsNavRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: AppInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.trackedSettingsIconBg,
              ),
              child: SvgPicture.asset(icon, width: 20.sp, height: 20.sp),
            ),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                  2.ph,
                  Text(
                    subtitle,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.trackedSettingsMutedText,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AppAssetsSvg.trackedSettingsChevronMutedIcon,
              width: 20.sp,
              height: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
