import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';
import 'tracker_detail_button.dart';
import 'tracker_detail_surface.dart';
import 'tracker_detail_text.dart';

class TrackerAuthenticityCard extends StatelessWidget {
  const TrackerAuthenticityCard({super.key, this.onSecurityDetails});

  final VoidCallback? onSecurityDetails;

  @override
  Widget build(BuildContext context) => TrackerDetailSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Expanded(
                  child: TrackerDetailText(AppStrings.trackerAuthenticityScore,
                      weight: FontWeight.w600),
                ),
                TrackerBadge(AppStrings.trackerVerified,
                    color: AppColors.trackerOnlineGreen, horizontal: 16),
              ],
            ),
            10.ph,
            Row(
              children: [
                const TrackerDetailText(
                    AppStrings.trackerAuthenticityScoreValue,
                    size: 32,
                    weight: FontWeight.w700,
                    color: AppColors.trackerOnlineGreen),
                10.pw,
                const TrackerDetailText(
                    AppStrings.trackerAuthenticityScoreTotal,
                    weight: FontWeight.w600,
                    color: AppColors.trackerMutedText),
              ],
            ),
            10.ph,
            const TrackerDetailText(AppStrings.trackerAuthenticityScoreNote,
                size: 12, color: AppColors.trackerMutedText),
            10.ph,
            TrackerDetailButton(AppStrings.trackerViewSecurityDetails,
                onTap: onSecurityDetails),
          ],
        ),
      );
}
