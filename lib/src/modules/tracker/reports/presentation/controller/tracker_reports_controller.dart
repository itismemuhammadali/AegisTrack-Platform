import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_report_entity.dart';

/// Figma sample export options; replace with the viewer report API.
class TrackerReportsController extends ChangeNotifier with Buffers {
  TrackerReportFormat format = TrackerReportFormat.pdf;
  String dateRange = 'This Month';
  String trackedUser = 'All Users (12)';
  bool includeAiNarrative = false;

  void setFormat(TrackerReportFormat value) {
    if (format == value) return;
    format = value;
    // The open preview belongs to the old format, so it is dismissed rather
    // than silently swapped under the viewer.
    showPreview = false;
    notifyListeners();
  }

  /// Whether the preview panel is open. It sits below the card, and the
  /// format decides which of the two previews is drawn.
  bool showPreview = false;

  void togglePreview() {
    showPreview = !showPreview;
    notifyListeners();
  }

  void closePreview() {
    if (!showPreview) return;
    showPreview = false;
    notifyListeners();
  }

  bool get isPdf => format == TrackerReportFormat.pdf;

  final List<TrackerReportPreviewRowEntity> pdfPreviewRows = const [
    TrackerReportPreviewRowEntity(
      logId: 'LG-8821',
      time: 'Dec 12 14:32',
      kind: 'Check-in',
      score: '94',
      scoreColor: AppColors.trackerOnlineGreen,
    ),
    TrackerReportPreviewRowEntity(
      logId: 'LG-8820',
      time: 'Dec 12 11:45',
      kind: 'Security Flag',
      score: '88',
      scoreColor: AppColors.trackerAcceptableText,
    ),
    TrackerReportPreviewRowEntity(
      logId: 'LG-8818',
      time: 'Dec 12 09:15',
      kind: 'Location',
      score: '94',
      scoreColor: AppColors.trackerOnlineGreen,
    ),
  ];

  /// Echoes the chosen filters back in the preview's subtitle.
  String get previewCaseLine => '${AppStrings.trackerReportPreviewCasePrefix}'
      '${trackedUser.replaceFirst(RegExp(r' \(\d+\)$'), '')} · $dateRange';

  void toggleAiNarrative() {
    includeAiNarrative = !includeAiNarrative;
    notifyListeners();
  }

  final List<String> inclusions = const [
    AppStrings.trackerReportIncludeLogs,
    AppStrings.trackerReportIncludeZoneEvents,
    AppStrings.trackerReportIncludeCheckIns,
    AppStrings.trackerReportIncludeSecurityFlags,
    AppStrings.trackerReportIncludeScoreSummary,
  ];

  /// Mirrors the options above, so the viewer can check what they asked for
  /// before exporting.
  List<TrackerReportSummaryEntity> get summary => [
        TrackerReportSummaryEntity(
            label: AppStrings.trackerReportPeriod, value: dateRange),
        const TrackerReportSummaryEntity(
            label: AppStrings.trackerReportUsersLabel, value: 'All (12)'),
        const TrackerReportSummaryEntity(
            label: AppStrings.trackerReportEstimatedLogs, value: '248'),
        const TrackerReportSummaryEntity(
            label: AppStrings.trackerReportEstimatedSize, value: '~340 KB'),
      ];

  final List<TrackerPreviousReportEntity> previousReports = const [
    TrackerPreviousReportEntity(
      title: 'Monthly Activity Report',
      meta: 'Nov 2024 · 2.4 MB · 248 logs · PDF',
    ),
    TrackerPreviousReportEntity(
      title: 'Wilson Case Export',
      meta: 'Nov 28, 2024 · 1.1 MB · 89 logs · PDF',
    ),
    TrackerPreviousReportEntity(
      title: 'Raw Log Data — Martinez',
      meta: 'Nov 20, 2024 · 340 KB · 156 logs · CSV',
    ),
  ];
}

final trackerReportsControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackerReportsController>(
  (ref) => TrackerReportsController(),
);
