import '../../../../../core/utils/app_exports.dart';

class TrackedSettingsSectionLabel extends StatelessWidget {
  const TrackedSettingsSectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.bodyMediumStyle?.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryWhite,
      ),
    );
  }
}
