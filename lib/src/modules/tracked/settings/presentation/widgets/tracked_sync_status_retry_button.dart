import '../../../../../core/utils/app_exports.dart';

class TrackedSyncStatusRetryButton extends StatelessWidget {
  const TrackedSyncStatusRetryButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: AppInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.twoFactorAccentPurple.withValues(alpha: 0.8),
          borderRadius: 18.circular,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssetsSvg.trackedSettingsSyncStatusIcon,
              width: 16.sp,
              height: 16.sp,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryWhite,
                BlendMode.srcIn,
              ),
            ),
            8.pw,
            Text(
              AppStrings.trackedSyncStatusRetrySync,
              style: context.bodyMediumStyle?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
