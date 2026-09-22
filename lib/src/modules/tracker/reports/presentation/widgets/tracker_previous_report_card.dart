import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../../domain/entities/tracker_report_entity.dart';

/// An already-generated report, with its lock, download and open actions.
class TrackerPreviousReportCard extends StatelessWidget {
  const TrackerPreviousReportCard({
    super.key,
    required this.report,
    this.onDownload,
    this.onOpen,
  });

  final TrackerPreviousReportEntity report;
  final VoidCallback? onDownload;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackerSurfaceFill),
        ),
        child: Row(
          children: [
            Container(
              padding: AppInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.trackerSurfaceFill,
                borderRadius: 20.circular,
              ),
              child: SvgPicture.asset(AppAssetsSvg.trackerReportFile,
                  width: 16.w, height: 16.w),
            ),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TrackerDetailText(report.title,
                      weight: FontWeight.w500, height: 20 / 14),
                  2.ph,
                  TrackerDetailText(report.meta,
                      size: 12, height: 16 / 12, color: AppColors.primaryWhite),
                ],
              ),
            ),
            8.pw,
            // The padlock is a state marker rather than a control: these
            // reports are sealed.
            SvgPicture.asset(AppAssetsSvg.trackerReportLock,
                width: 14.w, height: 14.w),
            8.pw,
            GestureDetector(
              onTap: onDownload,
              child: SvgPicture.asset(AppAssetsSvg.trackerReportDownload,
                  width: 16.w, height: 16.w),
            ),
            8.pw,
            GestureDetector(
              onTap: onOpen,
              child: SvgPicture.asset(AppAssetsSvg.trackerReportOpen,
                  width: 16.w, height: 16.w),
            ),
          ],
        ),
      );
}
