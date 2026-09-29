import '../../../../../core/utils/app_exports.dart';

class TrackedExportCenterTagChip extends StatelessWidget {
  const TrackedExportCenterTagChip({
    super.key,
    required this.label,
    this.color = AppColors.primaryWhite,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 12.circular,
      ),
      child: Text(
        label,
        style: context.bodySmallStyle?.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          height: 16 / 12,
          color: color,
        ),
      ),
    );
  }
}
