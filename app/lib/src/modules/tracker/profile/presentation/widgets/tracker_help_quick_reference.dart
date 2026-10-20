import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';

/// The rules of the viewer portal, ticked off one line at a time.
class TrackerHelpQuickReference extends StatelessWidget {
  const TrackerHelpQuickReference({super.key, required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) => TrackerSurface(
        borderColor: AppColors.trackerSurfaceFill,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(AppAssetsSvg.trackerHelpReference,
                    width: 16.w, height: 16.w),
                8.pw,
                Expanded(
                  child: Text(
                    AppStrings.trackerHelpQuickReference,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      height: 20 / 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.viewerSignInText,
                    ),
                  ),
                ),
              ],
            ),
            14.ph,
            for (final tip in tips) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 18.w,
                    height: 18.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.trackerSurfaceFill,
                      borderRadius: 30.circular,
                    ),
                    child: SvgPicture.asset(AppAssetsSvg.trackerHelpCheck,
                        width: 14.w, height: 14.w),
                  ),
                  8.pw,
                  Expanded(
                    child: Text(
                      tip,
                      style: context.bodySmallStyle?.copyWith(
                        fontSize: 12.sp,
                        height: 16 / 12,
                        color: AppColors.trackerMutedText,
                      ),
                    ),
                  ),
                ],
              ),
              if (tip != tips.last) 6.ph,
            ],
          ],
        ),
      );
}
