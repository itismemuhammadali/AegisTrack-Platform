import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_scaffold.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../../domain/entities/tracker_report_entity.dart';
import '../controller/tracker_reports_controller.dart';
import '../widgets/tracker_previous_report_card.dart';
import '../widgets/tracker_report_controls.dart';
import '../widgets/tracker_report_generate_card.dart';
import '../widgets/tracker_report_preview_card.dart';

/// Evidence report export, reached from a user's Generate Report action.
class TrackerReportsView extends ConsumerWidget {
  const TrackerReportsView({
    super.key,
    this.onExport,
    this.onShareLink,
  });

  /// Receives the format the viewer chose.
  final ValueChanged<TrackerReportFormat>? onExport;
  final VoidCallback? onShareLink;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerReportsControllerProvider);

    return TrackerDetailScaffold(
      title: AppStrings.trackerReportsTitle,
      subtitle: AppStrings.trackerReportsSubtitle,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerReportsBackTooltip,
      child: ListView(
        key: const PageStorageKey('tracker-reports'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          TrackerReportGenerateCard(
            controller: controller,
            onPreview: controller.togglePreview,
            onExport:
                onExport == null ? null : () => onExport!(controller.format),
          ),
          if (controller.showPreview) ...[
            24.ph,
            TrackerReportPreviewCard(
              title: controller.isPdf
                  ? AppStrings.trackerReportPdfPreviewTitle
                  : AppStrings.trackerReportCsvPreviewTitle,
              onClose: controller.closePreview,
              child: controller.isPdf
                  ? TrackerReportPdfPreview(
                      caseLine: controller.previewCaseLine,
                      rows: controller.pdfPreviewRows,
                    )
                  : const TrackerReportCsvPreview(),
            ),
          ],
          24.ph,
          Row(
            children: [
              const Expanded(
                child: TrackerDetailText(AppStrings.trackerReportPrevious,
                    weight: FontWeight.w600, height: 20 / 14),
              ),
              8.pw,
              const TrackerDetailText(AppStrings.trackerReportReadOnly,
                  size: 12, height: 16 / 12, color: AppColors.primaryWhite),
            ],
          ),
          10.ph,
          for (final report in controller.previousReports) ...[
            TrackerPreviousReportCard(report: report),
            10.ph,
          ],
          14.ph,
          TrackerReportActionButton(
            label: AppStrings.trackerReportShareLink,
            icon: AppAssetsSvg.trackerReportShare,
            onTap: onShareLink,
          ),
        ],
      ),
    );
  }
}
