import '../../../../../core/utils/app_exports.dart';

/// Read-only notice plus the refresh action closing the live tracking screen.
class TrackerLiveFooter extends StatelessWidget {
  const TrackerLiveFooter({super.key, this.onRefresh});

  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            width: double.infinity,
            padding: AppInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.trackerBorderSoft,
              borderRadius: 20.circular,
            ),
            child: Text(
              AppStrings.trackerLiveReadOnlyNotice,
              style: context.bodySmallStyle?.copyWith(
                fontSize: 12.sp,
                height: 19.5 / 12,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryWhite,
              ),
            ),
          ),
          16.ph,
          GestureDetector(
            onTap: onRefresh,
            child: Container(
              width: double.infinity,
              padding: AppInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.trackerSurfaceFill,
                borderRadius: 16.circular,
                border: Border.all(color: AppColors.trackerBorderSoft),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppAssetsSvg.trackerLiveRefresh,
                      width: 16.w, height: 16.w),
                  8.pw,
                  Text(
                    AppStrings.trackerRefresh,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      height: 20 / 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -.15,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
