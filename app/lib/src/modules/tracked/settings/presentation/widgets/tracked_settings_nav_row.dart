import '../../../../../core/utils/app_exports.dart';

class TrackedSettingsNavRow extends StatelessWidget {
  const TrackedSettingsNavRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.titleWeight = FontWeight.w500,
    this.gap = 12,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final FontWeight titleWeight;
  final double gap;

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
              height: 40.w,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.onboardingButtonGradientColors,
                  stops: AppColors.onboardingButtonGradientStops,
                ),
              ),
              child: SvgPicture.asset(icon, width: 20.sp, height: 20.sp),
            ),
            gap.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: titleWeight,
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
