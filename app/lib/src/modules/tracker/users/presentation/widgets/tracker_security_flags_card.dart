import '../../../../../core/utils/app_exports.dart';
import 'tracker_detail_surface.dart';
import 'tracker_detail_text.dart';

class TrackerSecurityFlagsCard extends StatelessWidget {
  const TrackerSecurityFlagsCard({
    super.key,
    required this.headline,
    required this.note,
    required this.flagged,
  });

  final String headline;
  final String note;

  /// Red alert icon when something was raised, green shield when clean.
  final bool flagged;

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
                    color: flagged
                        ? AppColors.trackerDangerRed.withValues(alpha: .2)
                        : AppColors.trackerSuccessGreen.withValues(alpha: .2),
                  ),
                  child: SvgPicture.asset(
                      flagged
                          ? AppAssetsSvg.trackerUserFlagAlert
                          : AppAssetsSvg.trackerUserDetailSecurity,
                      width: 16.w,
                      height: 16.w),
                ),
                10.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TrackerDetailText(headline, weight: FontWeight.w500),
                      const SizedBox(height: 4),
                      TrackerDetailText(note,
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
