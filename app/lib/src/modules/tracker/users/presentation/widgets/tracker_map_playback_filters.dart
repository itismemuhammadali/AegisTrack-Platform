import '../../../../../core/utils/app_exports.dart';

class TrackerMapPlaybackFilters extends StatelessWidget {
  const TrackerMapPlaybackFilters({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: AppInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.trackerSurfaceFill,
            borderRadius: 16.circular,
            border: Border.all(color: AppColors.trackerBorderSoft),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.trackerFilters,
                  style: context.bodyMediumStyle?.copyWith(
                    fontSize: 14.sp,
                    height: 20 / 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -.15,
                    color: AppColors.viewerSignInText,
                  ),
                ),
              ),
              SvgPicture.asset(AppAssetsSvg.trackerMapPlaybackFiltersChevron,
                  width: 16.w, height: 16.w),
            ],
          ),
        ),
      );
}
