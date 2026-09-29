import '../../../../../core/utils/app_exports.dart';

class TrackedSyncStatusSectionHeading extends StatelessWidget {
  const TrackedSyncStatusSectionHeading({
    required this.icon,
    required this.label,
    super.key,
  });

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 20.w,
          height: 20.w,
        ),
        8.pw,
        Text(
          label,
          style: context.bodyLargeStyle?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            height: 27 / 18,
            color: AppColors.primaryWhite,
          ),
        ),
      ],
    );
  }
}
