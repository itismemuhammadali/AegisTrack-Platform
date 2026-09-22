import '../../../../../core/utils/app_exports.dart';
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
                8.pw,
                Container(
                  padding: AppInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeFill,
                    borderRadius: 100.circular,
                  ),
                  child: TrackerDetailText(label,
                      size: 12, weight: FontWeight.w500, color: color),
                ),
              ],
            ),
            10.ph,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
            // The card's own button: wider padding and a heavier label than
            // the icon buttons closing the overview.
            GestureDetector(
              onTap: onSecurityDetails,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: AppInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.trackerSurfaceFill,
                  borderRadius: 20.circular,
                ),
                child: const TrackerDetailText(
                    AppStrings.trackerViewSecurityDetails,
                    weight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
}
