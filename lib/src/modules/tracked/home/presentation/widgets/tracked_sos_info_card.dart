import '../../../../../core/utils/app_exports.dart';

class TrackedSosInfoCard extends StatelessWidget {
  const TrackedSosInfoCard({super.key});

  static const _steps = [
    (AppAssetsSvg.trackedSosLocation, AppStrings.sosStepLocation),
    (AppAssetsSvg.trackedSosBell, AppStrings.sosStepViewer),
    (AppAssetsSvg.trackedSosAlert, AppStrings.sosStepLog),
    (AppAssetsSvg.trackedSosWifi, AppStrings.sosStepOffline),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.trackedSosRed.withValues(alpha: 0.1),
        borderRadius: 16.circular,
        border: Border.all(
          color: AppColors.trackedSosRed.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.sosWhenActivated,
            style: context.bodyMediumStyle?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 20 / 14,
              color: AppColors.primaryWhite,
            ),
          ),
          for (final (icon, text) in _steps) ...[
            10.ph,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  margin: AppInsets.only(top: 2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.trackedSosRed.withValues(alpha: 0.2),
                    borderRadius: 14.circular,
                  ),
                  child: SvgPicture.asset(icon, width: 12.w, height: 12.w),
                ),
                10.pw,
                Expanded(
                  child: Text(
                    text,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      height: 22.75 / 14,
                      color: AppColors.signInDarkSubtitle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
