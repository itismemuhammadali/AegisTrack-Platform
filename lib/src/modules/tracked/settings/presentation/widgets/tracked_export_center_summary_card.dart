import '../../../../../core/utils/app_exports.dart';

class TrackedExportCenterSummaryCard extends StatelessWidget {
  const TrackedExportCenterSummaryCard({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.trackedExportCenterCardBackground,
        borderRadius: 16.circular,
        border: Border.all(color: AppColors.trackedExportCenterCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.trackedExportCenterReadyToExport,
            style: context.bodySmallStyle?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.trackedExportCenterMutedText,
            ),
          ),
          10.ph,
          Text(
            '$count ${AppStrings.trackedExportCenterLogsLabel}',
            style: context.headlineSmallStyle?.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryWhite,
            ),
          ),
        ],
      ),
    );
  }
}
