import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../../domain/entities/tracker_report_entity.dart';

/// Shell shared by both previews: a title, a Close action and the mocked-up
/// document body.
class TrackerReportPreviewCard extends StatelessWidget {
  const TrackerReportPreviewCard({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
  });

  final String title;
  final Widget child;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackerSurfaceFill),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TrackerDetailText(title,
                      weight: FontWeight.w600, height: 20 / 14),
                ),
                8.pw,
                GestureDetector(
                  onTap: onClose,
                  behavior: HitTestBehavior.opaque,
                  child: const TrackerDetailText(
                      AppStrings.trackerReportPreviewClose,
                      size: 12,
                      height: 16 / 12,
                      color: AppColors.trackerMutedText),
                ),
              ],
            ),
            10.ph,
            child,
          ],
        ),
      );
}

/// PDF preview: a document header, three sample log lines and a footer.
class TrackerReportPdfPreview extends StatelessWidget {
  const TrackerReportPdfPreview({
    super.key,
    required this.caseLine,
    required this.rows,
  });

  final String caseLine;
  final List<TrackerReportPreviewRowEntity> rows;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: AppInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 20.circular,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: AppInsets.only(bottom: 12),
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColors.trackerSurfaceFill)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TrackerDetailText(
                            AppStrings.trackerReportPreviewHeading,
                            weight: FontWeight.w600),
                        4.ph,
                        TrackerDetailText(caseLine,
                            size: 12, color: AppColors.trackerMutedText),
                      ],
                    ),
                  ),
                  8.pw,
                  SvgPicture.asset(AppAssetsSvg.trackerReportPreviewDoc,
                      width: 16.w, height: 16.w),
                ],
              ),
            ),
            for (final row in rows)
              Container(
                padding: AppInsets.symmetric(vertical: 6),
                decoration: row == rows.last
                    ? null
                    : const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: AppColors.trackerSurfaceFill)),
                      ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TrackerDetailText(row.logId,
                          size: 12,
                          height: 16 / 12,
                          monospace: true,
                          color: AppColors.trackerMutedText),
                    ),
                    Expanded(
                      flex: 4,
                      child: TrackerDetailText(row.time,
                          size: 12, height: 16 / 12),
                    ),
                    Expanded(
                      flex: 4,
                      child: TrackerDetailText(row.kind,
                          size: 12,
                          height: 16 / 12,
                          color: AppColors.trackerMutedText),
                    ),
                    TrackerDetailText(row.score,
                        size: 12,
                        height: 16 / 12,
                        weight: FontWeight.w500,
                        color: row.scoreColor),
                  ],
                ),
              ),
            Container(
              padding: AppInsets.only(top: 8),
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: AppColors.trackerSurfaceFill)),
              ),
              child: Row(
                children: [
                  const TrackerDetailText(AppStrings.trackerReportPreviewScore,
                      size: 12, color: AppColors.trackerMutedText),
                  10.pw,
                  const Expanded(
                    child: TrackerDetailText(
                        AppStrings.trackerReportPreviewGenerated,
                        size: 12,
                        color: AppColors.trackerMutedText),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

/// CSV preview: the raw rows as they would be written to the file.
class TrackerReportCsvPreview extends StatelessWidget {
  const TrackerReportCsvPreview({super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 20.circular,
        ),
        child: Text(
          AppStrings.trackerReportCsvPreviewBody,
          style: context.bodySmallStyle?.copyWith(
            fontSize: 12.sp,
            height: 24 / 12,
            color: AppColors.primaryWhite,
          ),
        ),
      );
}
