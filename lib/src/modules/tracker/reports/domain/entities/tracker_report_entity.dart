import '../../../../../core/utils/app_exports.dart';

/// Export format. The label doubles as the button caption and as the suffix of
/// the export action ("Export CSV").
enum TrackerReportFormat {
  pdf(AppStrings.trackerReportFormatPdf),
  csv(AppStrings.trackerReportFormatCsv);

  const TrackerReportFormat(this.label);

  final String label;
}

/// A label/value row in the report summary.
class TrackerReportSummaryEntity {
  const TrackerReportSummaryEntity({required this.label, required this.value});

  final String label;
  final String value;
}

/// A report that has already been generated, kept read-only.
class TrackerPreviousReportEntity {
  const TrackerPreviousReportEntity({required this.title, required this.meta});

  final String title;

  /// Date, size, log count and format, joined for a single caption line.
  final String meta;
}

/// One log line in the PDF preview table.
class TrackerReportPreviewRowEntity {
  const TrackerReportPreviewRowEntity({
    required this.logId,
    required this.time,
    required this.kind,
    required this.score,
    required this.scoreColor,
  });

  final String logId;
  final String time;
  final String kind;
  final String score;
  final Color scoreColor;
}
