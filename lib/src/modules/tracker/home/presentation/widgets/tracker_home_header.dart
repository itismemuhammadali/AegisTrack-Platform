import '../../../../../core/utils/app_exports.dart';

class TrackerHomeHeader extends StatelessWidget {
  const TrackerHomeHeader(
      {super.key, required this.name, this.onNotifications});

  final String name;
  final VoidCallback? onNotifications;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: context.headlineSmallStyle?.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  height: 36 / 24,
                  color: AppColors.primaryWhite,
                ),
              ),
              2.ph,
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryWhite.withValues(alpha: 0.3),
                    ),
                  ),
                  8.pw,
                  Text(
                    AppStrings.trackerGoodMorning,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 20 / 14,
                      color: AppColors.primaryWhite.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        10.pw,
        GestureDetector(
          onTap: onNotifications,
          child: Container(
            width: 40.w,
            height: 40.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryWhite.withValues(alpha: 0.05),
              borderRadius: 18.circular,
              border: Border.all(
                color: AppColors.primaryWhite.withValues(alpha: 0.1),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  AppAssetsSvg.trackerBell,
                  width: 20.w,
                  height: 20.w,
                ),
                Positioned(
                  right: -4.w,
                  top: -2.w,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.trackedCheckInAmber,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Coloured banner used for the SOS event and the missing-log warning.
class TrackerEventBanner extends StatelessWidget {
  const TrackerEventBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.actionColor,
    this.leading,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final Color actionColor;
  final Widget? leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.05),
          borderRadius: 24.circular,
          border: Border.all(color: accent.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryblack.withValues(alpha: 0.25),
              blurRadius: 50,
              spreadRadius: -12,
              offset: Offset(0, 25.h),
            ),
          ],
        ),
        child: Row(
          children: [
            leading ??
                ClipOval(
                  child: Image.asset(
                    AppAssetsPng.trackerUserAvatar,
                    width: 40.w,
                    height: 40.w,
                    fit: BoxFit.cover,
                  ),
                ),
            10.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 20 / 14,
                      color: AppColors.viewerSignInText,
                    ),
                  ),
                  2.ph,
                  Text(
                    subtitle,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      height: 16 / 12,
                      color: AppColors.primaryWhite.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            8.pw,
            Container(
              padding: AppInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: actionColor,
                borderRadius: 100.circular,
              ),
              child: Text(
                AppStrings.trackerViewDetails,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
