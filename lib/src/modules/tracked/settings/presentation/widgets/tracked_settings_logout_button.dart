import '../../../../../core/utils/app_exports.dart';

class TrackedSettingsLogoutButton extends StatelessWidget {
  const TrackedSettingsLogoutButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: AppInsets.symmetric(vertical: 17),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryWhite.withValues(alpha: 0.05),
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackedSettingsCardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssetsSvg.trackedSettingsLogoutIcon,
              width: 20.sp,
              height: 20.sp,
            ),
            8.pw,
            Text(
              AppStrings.trackedSettingsLogout,
              style: context.bodyLargeStyle?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.trackedSettingsLogoutRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
