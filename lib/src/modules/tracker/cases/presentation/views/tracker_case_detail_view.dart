import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_scaffold.dart';
import '../../domain/entities/tracker_case_entity.dart';
import '../controller/tracker_cases_controller.dart';
import '../widgets/tracker_case_detail_header.dart';
import '../widgets/tracker_case_event_card.dart';
import '../widgets/tracker_case_evidence_card.dart';
import '../widgets/tracker_case_evidence_summary.dart';
import '../widgets/tracker_case_info_section.dart';
import '../widgets/tracker_case_report_card.dart';
import '../widgets/tracker_case_subject_card.dart';
import '../widgets/tracker_case_tab_bar.dart';

/// Read-only case file, reached by tapping a case on the Cases tab.
class TrackerCaseDetailView extends ConsumerWidget {
  const TrackerCaseDetailView({
    super.key,
    required this.caseEntity,
    this.onExport,
    this.onViewLog,
    this.onDownloadReport,
  });

  final TrackerCaseEntity caseEntity;
  final VoidCallback? onExport;
  final ValueChanged<TrackerCaseEventEntity>? onViewLog;

  /// Takes the report and the format label the viewer tapped, so the caller
  /// can tell a PDF download from a CSV one.
  final void Function(TrackerCaseReportEntity report, String format)?
      onDownloadReport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerCasesControllerProvider);

    return TrackerDetailScaffold(
      title: caseEntity.title,
      backTooltip: AppStrings.trackerCaseDetailClose,
      header: TrackerCaseDetailHeader(
        id: caseEntity.id,
        title: caseEntity.title,
        status: caseEntity.status,
        statusColor: caseEntity.statusColor,
      ),
      child: ListView(
        key: const PageStorageKey('tracker-case-detail'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          TrackerCaseInfoSection(rows: controller.caseInfo),
          24.ph,
          Text(
            AppStrings.trackerCaseTrackedUsers,
            style: context.bodyMediumStyle?.copyWith(
              fontSize: 14.sp,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: AppColors.trackerMutedText,
            ),
          ),
          10.ph,
          for (final subject in controller.caseSubjects) ...[
            TrackerCaseSubjectCard(subject: subject),
            10.ph,
          ],
          14.ph,
          TrackerCaseEvidenceSummary(stats: controller.evidenceStats),
          24.ph,
          TrackerCaseTabBar(
            tabs: TrackerCasesController.detailTabs,
            selected: controller.detailTab,
            onSelected: controller.setDetailTab,
          ),
          24.ph,
          if (controller.showsTimeline)
            for (final event in controller.caseEvents) ...[
              TrackerCaseEventCard(
                event: event,
                onViewLog: onViewLog == null ? null : () => onViewLog!(event),
              ),
              10.ph,
            ],
          if (controller.showsEvidence)
            for (final evidence in controller.caseEvidence) ...[
              TrackerCaseEvidenceCard(evidence: evidence),
              10.ph,
            ],
          if (controller.showsReports)
            for (final report in controller.caseReports) ...[
              TrackerCaseReportCard(
                report: report,
                onDownloadPdf: onDownloadReport == null
                    ? null
                    : () => onDownloadReport!(
                        report, AppStrings.trackerCaseReportPdf),
                onDownloadCsv: onDownloadReport == null
                    ? null
                    : () => onDownloadReport!(
                        report, AppStrings.trackerCaseReportCsv),
              ),
              10.ph,
            ],
          14.ph,
          GestureDetector(
            onTap: onExport,
            child: Container(
              alignment: Alignment.center,
              padding: AppInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: AppColors.trackerPurpleDeep,
                borderRadius: 46.circular,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssetsSvg.trackerCaseDetailExport,
                    width: 16.w,
                    height: 16.w,
                  ),
                  8.pw,
                  Text(
                    AppStrings.trackerCaseExportReport,
                    style: context.titleMediumStyle?.copyWith(
                      fontSize: 16.sp,
                      height: 24 / 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.viewerSignInText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
