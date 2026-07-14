import '../../../../../core/utils/app_exports.dart';

class TrackedLogTagChip extends StatelessWidget {
  const TrackedLogTagChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 12.circular,
      ),
      child: Text(
        label,
        style: context.bodySmallStyle?.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.trackedLogTagText,
        ),
      ),
    );
  }
}
