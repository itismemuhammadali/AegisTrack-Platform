import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_log_detail_entity.dart';
import 'tracker_detail_text.dart';

/// The authenticity score for this log, with the scale it sits on and a way
/// through to the full security breakdown.
class TrackerLogScoreCard extends StatelessWidget {
  const TrackerLogScoreCard({
    super.key,
    required this.log,
    required this.bands,
    this.onSecurityDetails,
  });

  final TrackerLogDetailEntity log;
  final List<TrackerLogScoreBandEntity> bands;
  final VoidCallback? onSecurityDetails;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackerBorderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TrackerDetailText(log.score,
                    size: 36,
                    weight: FontWeight.w700,
                    height: 40 / 36,
                    color: log.scoreColor),
                8.pw,
                Flexible(
                  child: Padding(
                    // Sits on the score's baseline rather than its box.
                    padding: AppInsets.only(bottom: 4),
                    child: TrackerDetailText(AppStrings.trackerLogScoreCaption,
                        height: 20 / 14, color: AppColors.primaryWhite),
                  ),
                ),
              ],
            ),
            10.ph,
            TrackerDetailText(log.scoreNote, size: 12, height: 16 / 12),
            10.ph,
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: [
                for (final band in bands) _TrackerLogScoreBand(band: band),
              ],
            ),
            10.ph,
            GestureDetector(
              onTap: onSecurityDetails,
              behavior: HitTestBehavior.opaque,
              child: Container(
                alignment: Alignment.center,
                padding: AppInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.trackerLogSecurityFill,
                  borderRadius: 20.circular,
                  border: Border.all(color: AppColors.trackerLogSecurityBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppAssetsSvg.trackerLogShield,
                        width: 14.w, height: 14.w),
                    8.pw,
                    const TrackerDetailText(
                      AppStrings.trackerLogViewSecurityDetails,
                      size: 12,
                      height: 16 / 12,
                      weight: FontWeight.w600,
                      color: AppColors.trackerInfoBlue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class _TrackerLogScoreBand extends StatelessWidget {
  const _TrackerLogScoreBand({required this.band});

  final TrackerLogScoreBandEntity band;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: band.fill,
          borderRadius: 16.circular,
          border: Border.all(color: band.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TrackerDetailText(band.label,
                size: 10,
                height: 15 / 10,
                weight: FontWeight.w600,
                color: band.color),
            4.pw,
            Opacity(
              opacity: .7,
              child: TrackerDetailText(band.range,
                  size: 10, height: 15 / 10, color: band.color),
            ),
          ],
        ),
      );
}
