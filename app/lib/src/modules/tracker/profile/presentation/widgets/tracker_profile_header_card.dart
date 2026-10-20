import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';

class TrackerProfileHeaderCard extends StatelessWidget {
  const TrackerProfileHeaderCard({
    super.key,
    required this.name,
    required this.email,
    required this.stats,
    this.onEdit,
  });

  final String name;
  final String email;
  final List<(String, String)> stats;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) => TrackerSurface(
        padding: 20,
        borderColor: AppColors.trackerSurfaceFill,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 64.w,
                  height: 64.w,
                  child: Stack(
                    children: [
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.trackerPurpleDeep,
                              AppColors.trackerPurpleLight,
                            ],
                          ),
                        ),
                        child: SizedBox.expand(),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: onEdit,
                          child: Container(
                            padding: AppInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.trackerPurpleDeep,
                            ),
                            child: SvgPicture.asset(
                                AppAssetsSvg.trackerProfileEdit,
                                width: 12.w,
                                height: 12.w),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                16.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: context.titleMediumStyle?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.viewerSignInText,
                        ),
                      ),
                      4.ph,
                      Text(
                        email,
                        style: context.bodySmallStyle?.copyWith(
                          fontSize: 12.sp,
                          color: AppColors.trackerMutedText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      10.ph,
                      Wrap(
                        spacing: 14.w,
                        runSpacing: 6.h,
                        children: [
                          Container(
                            padding:
                                AppInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.trackerSurfaceFill,
                              borderRadius: 100.circular,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                    AppAssetsSvg.trackerProfileViewerShield,
                                    width: 12.w,
                                    height: 12.w),
                                4.pw,
                                Text(
                                  AppStrings.trackerAuthorizedViewer,
                                  style: context.bodySmallStyle?.copyWith(
                                    fontSize: 12.sp,
                                    color: AppColors.primaryWhite,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const TrackerBadge(AppStrings.trackerBadgeExpert,
                              background: AppColors.trackerSurfaceFill),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            16.ph,
            const Divider(height: 1, color: AppColors.trackerBorderSoft),
            16.ph,
            Row(
              children: [
                for (final (value, label) in stats)
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          value,
                          style: context.titleMediumStyle?.copyWith(
                            fontSize: 18.sp,
                            height: 28 / 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.viewerSignInText,
                          ),
                        ),
                        Text(
                          label,
                          style: context.bodySmallStyle?.copyWith(
                            fontSize: 12.sp,
                            height: 16 / 12,
                            color: AppColors.trackerMutedText,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
}
