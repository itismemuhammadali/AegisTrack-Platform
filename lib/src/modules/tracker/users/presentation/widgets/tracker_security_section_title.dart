import '../../../../../core/utils/app_exports.dart';

class TrackerSecuritySectionTitle extends StatelessWidget {
  const TrackerSecuritySectionTitle(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: context.bodySmallStyle?.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryWhite,
          letterSpacing: 1.2,
          height: 16 / 12,
        ),
      );
}
