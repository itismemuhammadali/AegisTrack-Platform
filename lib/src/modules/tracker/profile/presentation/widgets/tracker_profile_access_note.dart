import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';

class TrackerProfileAccessNote extends StatelessWidget {
  const TrackerProfileAccessNote({super.key});

  @override
  Widget build(BuildContext context) => TrackerSurface(
        borderColor: AppColors.trackerSurfaceFill,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(AppAssetsSvg.trackerProfileAccessLock,
                width: 16.w, height: 16.w),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.trackerReadOnlyAccess,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.primaryWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  3.ph,
                  Text(
                    AppStrings.trackerReadOnlyDetail,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.trackerFaintText,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
