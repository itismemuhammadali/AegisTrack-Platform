import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_case_entity.dart';

/// A generated case report with its two download formats.
class TrackerCaseReportCard extends StatelessWidget {
  const TrackerCaseReportCard({
    super.key,
    required this.report,
    this.onDownloadPdf,
    this.onDownloadCsv,
  });

  final TrackerCaseReportEntity report;
  final VoidCallback? onDownloadPdf;
  final VoidCallback? onDownloadCsv;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.symmetric(horizontal: 16, vertical: 12),
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
                Padding(
                  padding: AppInsets.only(top: 2),
                  child: SvgPicture.asset(
                    AppAssetsSvg.trackerCaseDetailReport,
                    width: 20.w,
                    height: 20.w,
                  ),
                ),
                12.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.title,
                        style: context.bodyMediumStyle?.copyWith(
                          fontSize: 14.sp,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                          color: AppColors.viewerSignInText,
                        ),
                      ),
                      4.ph,
                      Text(
                        report.generated,
                        style: context.bodySmallStyle?.copyWith(
                          fontSize: 12.sp,
                          height: 1.2,
                          color: AppColors.trackerMutedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            10.ph,
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _TrackerCaseReportAction(
                      label: AppStrings.trackerCaseReportPdf,
                      icon: AppAssetsSvg.trackerCaseDetailPdf,
                      fill: AppColors.trackerPurpleDeep,
                      labelColor: AppColors.viewerSignInText,
                      onTap: onDownloadPdf,
                    ),
                  ),
                  24.pw,
                  Expanded(
                    child: _TrackerCaseReportAction(
                      label: AppStrings.trackerCaseReportCsv,
                      icon: AppAssetsSvg.trackerCaseDetailCsv,
                      fill: AppColors.trackerSurfaceFill,
                      labelColor: AppColors.primaryWhite,
                      bordered: true,
                      onTap: onDownloadCsv,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _TrackerCaseReportAction extends StatelessWidget {
  const _TrackerCaseReportAction({
    required this.label,
    required this.icon,
    required this.fill,
    required this.labelColor,
    this.bordered = false,
    this.onTap,
  });

  final String label;
  final String icon;
  final Color fill;
  final Color labelColor;
  final bool bordered;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        // Opaque, so the padding around the label answers the tap too.
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          padding: AppInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: 16.circular,
            border: bordered
                ? Border.all(color: AppColors.trackerSurfaceFill)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(icon, width: 12.w, height: 12.w),
              6.pw,
              Text(
                label,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  height: 1.2,
                  color: labelColor,
                ),
              ),
            ],
          ),
        ),
      );
}
