import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';
import 'tracker_detail_button.dart';
import 'tracker_detail_surface.dart';
import 'tracker_detail_text.dart';

class TrackerAuthenticityCard extends StatelessWidget {
  const TrackerAuthenticityCard({
    super.key,
    required this.score,
    required this.label,
    required this.note,
    required this.color,
    required this.badgeFill,
    this.onSecurityDetails,
  });

  final String score;

  /// Verified for a tracked user, Suspect for an unidentified subject.
  final String label;
  final String note;
  final Color color;
  final Color badgeFill;
  final VoidCallback? onSecurityDetails;

  @override
  Widget build(BuildContext context) => TrackerDetailSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: TrackerDetailText(AppStrings.trackerAuthenticityScore,
                      weight: FontWeight.w600),
                ),
                TrackerBadge(label,
                    color: color, background: badgeFill, horizontal: 16),
              ],
            ),
            10.ph,
            Row(
              children: [
                TrackerDetailText(score,
                    size: 32, weight: FontWeight.w700, color: color),
                10.pw,
                const TrackerDetailText(
                    AppStrings.trackerAuthenticityScoreTotal,
                    weight: FontWeight.w600,
                    color: AppColors.trackerMutedText),
              ],
            ),
            10.ph,
            TrackerDetailText(note,
                size: 12, color: AppColors.trackerMutedText),
            10.ph,
            TrackerDetailButton(AppStrings.trackerViewSecurityDetails,
                onTap: onSecurityDetails),
          ],
        ),
      );
}
