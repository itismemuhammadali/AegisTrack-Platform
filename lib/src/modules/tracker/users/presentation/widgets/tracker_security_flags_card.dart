import '../../../../../core/utils/app_exports.dart';
import 'tracker_detail_surface.dart';
import 'tracker_detail_text.dart';

class TrackerSecurityFlagsCard extends StatelessWidget {
  const TrackerSecurityFlagsCard({super.key});

  @override
  Widget build(BuildContext context) => TrackerDetailSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TrackerDetailText(AppStrings.trackerSecurityFlags,
                weight: FontWeight.w600),
            10.ph,
            Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.trackerSuccessGreen.withValues(alpha: .2),
                  ),
                  child: SvgPicture.asset(
                      AppAssetsSvg.trackerUserDetailSecurity,
                      width: 16.w,
                      height: 16.w),
                ),
                10.pw,
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TrackerDetailText(AppStrings.trackerNoSecurityFlags,
                          weight: FontWeight.w500),
                      SizedBox(height: 4),
                      TrackerDetailText(AppStrings.trackerAllChecksPassed,
                          size: 12, color: AppColors.trackerMutedText),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
