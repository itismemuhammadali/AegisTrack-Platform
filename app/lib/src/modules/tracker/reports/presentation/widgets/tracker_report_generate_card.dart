import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../../domain/entities/tracker_report_entity.dart';
import '../controller/tracker_reports_controller.dart';
import 'tracker_report_controls.dart';

/// The export configuration card: format, filters, what the export contains,
/// a summary of the request and the two actions.
class TrackerReportGenerateCard extends StatelessWidget {
  const TrackerReportGenerateCard({
    super.key,
    required this.controller,
    this.onDateRange,
    this.onTrackedUser,
    this.onPreview,
    this.onExport,
  });

  final TrackerReportsController controller;
  final VoidCallback? onDateRange;
  final VoidCallback? onTrackedUser;
  final VoidCallback? onPreview;
  final VoidCallback? onExport;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 20.circular,
          border: Border.all(color: AppColors.trackerSurfaceFill),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TrackerReportCardHeader(),
            16.ph,
            TrackerReportFormatToggle(
              selected: controller.format,
              onSelected: controller.setFormat,
            ),
            16.ph,
            TrackerReportDropdown(
              label: AppStrings.trackerReportDateRange,
              icon: AppAssetsSvg.trackerReportCalendar,
              value: controller.dateRange,
              onTap: onDateRange,
            ),
            16.ph,
            TrackerReportDropdown(
              label: AppStrings.trackerReportTrackedUser,
              icon: AppAssetsSvg.trackerReportUsers,
              value: controller.trackedUser,
              onTap: onTrackedUser,
            ),
            16.ph,
            // PDF exports are assembled from sections, so they list what the
            // document contains; a CSV is a flat table, so it lists columns.
            if (controller.isPdf) ...[
              const TrackerReportFieldLabel(AppStrings.trackerReportIncludes),
              10.ph,
              for (final item in controller.inclusions) ...[
                Row(
                  children: [
                    SvgPicture.asset(AppAssetsSvg.trackerReportCheck,
                        width: 14.w, height: 14.w),
                    8.pw,
                    Expanded(
                      child: TrackerDetailText(item,
                          size: 12,
                          height: 16 / 12,
                          color: AppColors.primaryWhite),
                    ),
                  ],
                ),
                10.ph,
              ],
              TrackerReportSwitch(
                label: AppStrings.trackerReportAiNarrative,
                value: controller.includeAiNarrative,
                onTap: controller.toggleAiNarrative,
              ),
            ] else ...[
              const TrackerReportFieldLabel(AppStrings.trackerReportCsvColumns),
              6.ph,
              Container(
                width: double.infinity,
                padding: AppInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.trackerSurfaceFill,
                  borderRadius: 20.circular,
                ),
                child: const TrackerDetailText(
                    AppStrings.trackerReportCsvColumnList,
                    size: 12,
                    height: 19.5 / 12,
                    color: AppColors.primaryWhite),
              ),
            ],
            16.ph,
            _TrackerReportSummary(rows: controller.summary),
            16.ph,
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: TrackerReportActionButton(
                      label: AppStrings.trackerReportPreviewAction,
                      icon: AppAssetsSvg.trackerReportPreview,
                      onTap: onPreview,
                    ),
                  ),
                  8.pw,
                  Expanded(
                    child: TrackerReportActionButton(
                      label: AppStrings.trackerReportExportPrefix +
                          controller.format.label,
                      icon: AppAssetsSvg.trackerReportExport,
                      primary: true,
                      onTap: onExport,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _TrackerReportCardHeader extends StatelessWidget {
  const _TrackerReportCardHeader();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            padding: AppInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.trackerSurfaceFill,
              borderRadius: 20.circular,
            ),
            child: SvgPicture.asset(AppAssetsSvg.trackerReportDoc,
                width: 20.w, height: 20.w),
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TrackerDetailText(AppStrings.trackerGenerateReport,
                    size: 20, weight: FontWeight.w600, height: 30 / 20),
                const TrackerDetailText(AppStrings.trackerReportConfigure,
                    size: 12, height: 16 / 12, color: AppColors.primaryWhite),
              ],
            ),
          ),
          8.pw,
          Container(
            padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.trackerOnlinePillFill,
              borderRadius: 100.circular,
              border: Border.all(color: AppColors.trackerSuccessSurface),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(AppAssetsSvg.trackerReportEncrypted,
                    width: 12.w, height: 12.w),
                4.pw,
                const TrackerDetailText(AppStrings.trackerReportEncryptedBadge,
                    size: 12,
                    height: 16 / 12,
                    color: AppColors.trackerOnlineGreen),
              ],
            ),
          ),
        ],
      );
}

class _TrackerReportSummary extends StatelessWidget {
  const _TrackerReportSummary({required this.rows});

  final List<TrackerReportSummaryEntity> rows;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 20.circular,
          border: Border.all(color: AppColors.trackerSurfaceFill),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TrackerDetailText(AppStrings.trackerReportSummary,
                size: 12, weight: FontWeight.w500, height: 16 / 12),
            6.ph,
            for (final row in rows) ...[
              Row(
                children: [
                  TrackerDetailText(row.label,
                      size: 12, height: 16 / 12, color: AppColors.primaryWhite),
                  8.pw,
                  Expanded(
                    child: Text(
                      row.value,
                      textAlign: TextAlign.right,
                      style: context.bodySmallStyle?.copyWith(
                        fontSize: 12.sp,
                        height: 16 / 12,
                        color: AppColors.viewerSignInText,
                      ),
                    ),
                  ),
                ],
              ),
              if (row != rows.last) 8.ph,
            ],
          ],
        ),
      );
}
