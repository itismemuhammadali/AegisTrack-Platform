import '../../../../../core/utils/app_exports.dart';

class TrackedSyncStatusStatCard extends StatelessWidget {
  const TrackedSyncStatusStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
  });

  final String icon;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: AppInsets.all(17),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite.withValues(alpha: 0.05),
          borderRadius: 16.circular,
          border: Border.all(
            color: AppColors.primaryWhite.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  icon,
                  width: 16.w,
                  height: 16.w,
                ),
                8.pw,
                Text(
                  label,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                    color: AppColors.trackedLogTagText,
                  ),
                ),
              ],
            ),
            4.ph,
            Text(
              '$count',
              style: context.headlineSmallStyle?.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                height: 32 / 24,
                color: AppColors.primaryWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
