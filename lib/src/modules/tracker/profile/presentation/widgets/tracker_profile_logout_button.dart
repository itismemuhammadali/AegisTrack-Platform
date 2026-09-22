import '../../../../../core/utils/app_exports.dart';

class TrackerProfileLogoutButton extends StatelessWidget {
  const TrackerProfileLogoutButton({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onLogout,
        child: Container(
          padding: AppInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.trackerCriticalRed.withValues(alpha: .1),
            borderRadius: 16.circular,
            border: Border.all(
                color: AppColors.trackerCriticalRed.withValues(alpha: .2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssetsSvg.trackerProfileLogout,
                  width: 16.w, height: 16.w),
              8.pw,
              Text(
                AppStrings.trackerLogout,
                style: context.bodyMediumStyle?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.trackerCriticalRed,
                ),
              ),
            ],
          ),
        ),
      );
}
