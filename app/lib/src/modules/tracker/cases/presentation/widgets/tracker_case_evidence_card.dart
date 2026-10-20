import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_case_entity.dart';

/// A sealed evidence record: the log id, the event it came from, and the
/// immutability badge that tells the viewer it cannot be edited.
class TrackerCaseEvidenceCard extends StatelessWidget {
  const TrackerCaseEvidenceCard({super.key, required this.evidence});

  final TrackerCaseEvidenceEntity evidence;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 20.circular,
          border: Border.all(color: AppColors.trackerSurfaceFill),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    evidence.logId,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      height: 16 / 12,
                      fontFamily: 'monospace',
                      color: AppColors.primaryWhite,
                    ),
                  ),
                ),
                8.pw,
                Container(
                  padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: evidence.kind.fill,
                    borderRadius: 100.circular,
                  ),
                  child: Text(
                    evidence.kind.label,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      height: 16 / 12,
                      fontWeight: FontWeight.w500,
                      color: evidence.kind.color,
                    ),
                  ),
                ),
              ],
            ),
            12.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: AppInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.trackerWarningSurface,
                      borderRadius: 16.circular,
                      border: Border.all(color: AppColors.trackerWarningBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AppAssetsSvg.trackerCaseDetailLock,
                          width: 12.w,
                          height: 12.w,
                        ),
                        6.pw,
                        Flexible(
                          child: Text(
                            AppStrings.trackerCaseLockedImmutable,
                            overflow: TextOverflow.ellipsis,
                            style: context.bodySmallStyle?.copyWith(
                              fontSize: 12.sp,
                              height: 16 / 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: .3,
                              color: AppColors.trackerAmber,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                8.pw,
                Text(
                  evidence.score,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    height: 16 / 12,
                    fontWeight: FontWeight.w600,
                    color: evidence.scoreColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
