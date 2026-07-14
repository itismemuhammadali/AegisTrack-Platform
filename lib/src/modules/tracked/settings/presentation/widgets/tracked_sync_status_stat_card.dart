import '../../../../../core/utils/app_exports.dart';

class TrackedSyncStatusStatCard extends StatelessWidget {
  const TrackedSyncStatusStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  final String icon;
  final String label;
  final int count;
  final Color color;

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
                  width: 16.sp,
                  height: 16.sp,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
                8.pw,
                Text(
                  label,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.trackedLogTagText,
                  ),
                ),
              ],
            ),
            8.ph,
            Text(
              '$count',
              style: context.headlineSmallStyle?.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
