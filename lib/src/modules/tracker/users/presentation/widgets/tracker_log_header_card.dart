import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_log_detail_entity.dart';
import 'tracker_detail_text.dart';

/// Top of the log record: its sequence number, archive status, event kind and
/// the timestamp the record was sealed with.
class TrackerLogHeaderCard extends StatelessWidget {
  const TrackerLogHeaderCard({super.key, required this.log});

  final TrackerLogDetailEntity log;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 20.circular,
          border: Border.all(color: AppColors.trackerBorderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    log.sequence,
                    style: context.bodyMediumStyle?.copyWith(
                      fontSize: 14.sp,
                      height: 16 / 14,
                      fontFamily: 'monospace',
                      color: AppColors.primaryWhite,
                    ),
                  ),
                ),
                8.pw,
                Container(
                  padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.trackerBorderSoft,
                    borderRadius: 100.circular,
                  ),
                  child: TrackerDetailText(log.status,
                      size: 12,
                      height: 16 / 12,
                      weight: FontWeight.w500,
                      color: AppColors.primaryWhite),
                ),
              ],
            ),
            10.ph,
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: AppInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: log.kindFill,
                  borderRadius: 100.circular,
                ),
                child: TrackerDetailText(log.kindLabel,
                    size: 12,
                    height: 16 / 12,
                    weight: FontWeight.w500,
                    color: log.kindColor),
              ),
            ),
            10.ph,
            Row(
              children: [
                Flexible(
                  child: TrackerDetailText(log.timestamp,
                      size: 18, weight: FontWeight.w600, height: 28 / 18),
                ),
                6.pw,
                SvgPicture.asset(AppAssetsSvg.trackerLogLockSmall,
                    width: 12.w, height: 12.w),
              ],
            ),
          ],
        ),
      );
}
