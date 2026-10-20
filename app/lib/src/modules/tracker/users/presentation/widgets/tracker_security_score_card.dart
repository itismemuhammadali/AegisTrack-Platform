import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';
import 'tracker_detail_text.dart';

class TrackerSecurityScoreCard extends StatelessWidget {
  const TrackerSecurityScoreCard({super.key, required this.score});

  final String score;

  @override
  Widget build(BuildContext context) => TrackerSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TrackerDetailText(score,
                    size: 48,
                    weight: FontWeight.w700,
                    color: AppColors.trackerOnlineGreen,
                    height: 1),
                8.pw,
                Padding(
                  padding: AppInsets.only(bottom: 8),
                  child: const TrackerDetailText(
                      AppStrings.trackerSecurityScoreCaption,
                      color: AppColors.primaryWhite,
                      height: 20 / 14),
                ),
              ],
            ),
            14.ph,
            const TrackerDetailText(AppStrings.trackerSecurityScoreNote,
                weight: FontWeight.w500,
                color: AppColors.primaryWhite,
                height: 20 / 14),
            14.ph,
            const TrackerDetailText(AppStrings.trackerSecurityLogReference,
                size: 12,
                color: AppColors.primaryWhite,
                height: 20 / 14,
                monospace: true),
          ],
        ),
      );
}
