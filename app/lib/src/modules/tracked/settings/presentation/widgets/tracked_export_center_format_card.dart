import '../../../../../core/utils/app_exports.dart';
import 'tracked_export_center_tag_chip.dart';

class TrackedExportCenterFormatCard extends StatelessWidget {
  const TrackedExportCenterFormatCard({
    super.key,
    required this.format,
    this.onTap,
  });

  final TrackedExportFormat format;
  final VoidCallback? onTap;

  String get _icon => switch (format) {
        TrackedExportFormat.encryptedPdf =>
          AppAssetsSvg.trackedExportCenterPdfIcon,
        TrackedExportFormat.spreadsheet =>
          AppAssetsSvg.trackedExportCenterSpreadsheetIcon,
        TrackedExportFormat.email => AppAssetsSvg.trackedExportCenterEmailIcon,
      };

  Color get _iconBackground => switch (format) {
        TrackedExportFormat.encryptedPdf =>
          AppColors.primaryWhite.withValues(alpha: 0.1),
        TrackedExportFormat.spreadsheet =>
          AppColors.trackedExportCenterSpreadsheetIconBackground,
        TrackedExportFormat.email =>
          AppColors.trackedExportCenterEmailIconBackground,
      };

  String get _title => switch (format) {
        TrackedExportFormat.encryptedPdf =>
          AppStrings.trackedExportCenterPdfTitle,
        TrackedExportFormat.spreadsheet =>
          AppStrings.trackedExportCenterSpreadsheetTitle,
        TrackedExportFormat.email => AppStrings.trackedExportCenterEmailTitle,
      };

  String get _description => switch (format) {
        TrackedExportFormat.encryptedPdf =>
          AppStrings.trackedExportCenterPdfDescription,
        TrackedExportFormat.spreadsheet =>
          AppStrings.trackedExportCenterSpreadsheetDescription,
        TrackedExportFormat.email =>
          AppStrings.trackedExportCenterEmailDescription,
      };

  List<TrackedExportCenterTagChip> get _tagChips => switch (format) {
        TrackedExportFormat.encryptedPdf => [
            TrackedExportCenterTagChip(
              label: AppStrings.trackedExportCenterTagSecure,
              color: AppColors.trackedLogSyncedGreen,
            ),
            TrackedExportCenterTagChip(
              label: AppStrings.trackedExportCenterTagPrintable,
            ),
          ],
        TrackedExportFormat.spreadsheet => [
            TrackedExportCenterTagChip(
              label: AppStrings.trackedExportCenterTagCsvFormat,
            ),
            TrackedExportCenterTagChip(
              label: AppStrings.trackedExportCenterTagEditable,
            ),
          ],
        TrackedExportFormat.email => [
            TrackedExportCenterTagChip(
              label: AppStrings.trackedExportCenterTagPdfAttached,
            ),
            TrackedExportCenterTagChip(
              label: AppStrings.trackedExportCenterTagInstant,
            ),
          ],
      };

  bool get _isSecure => format == TrackedExportFormat.encryptedPdf;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: AppInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.trackedExportCenterCardBackground,
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackedExportCenterCardBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _iconBackground,
                borderRadius: 16.circular,
              ),
              child: SvgPicture.asset(_icon, width: 28.w, height: 28.w),
            ),
            16.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _title,
                          style: context.bodyMediumStyle?.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            height: 24 / 16,
                            color: AppColors.primaryWhite,
                          ),
                        ),
                      ),
                      if (_isSecure) ...[
                        8.pw,
                        SvgPicture.asset(
                          AppAssetsSvg.trackedExportCenterLockIcon,
                          width: 16.w,
                          height: 16.w,
                        ),
                      ],
                    ],
                  ),
                  4.ph,
                  Text(
                    _description,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 20 / 14,
                      color: AppColors.trackedExportCenterMutedText,
                    ),
                  ),
                  8.ph,
                  Row(
                    children: [
                      for (var i = 0; i < _tagChips.length; i++) ...[
                        _tagChips[i],
                        if (i != _tagChips.length - 1) 8.pw,
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
