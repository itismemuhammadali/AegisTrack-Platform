import '../../../../../core/utils/app_exports.dart';

class TrackedSyncStatusSectionHeading extends StatelessWidget {
  const TrackedSyncStatusSectionHeading({
    required this.icon,
    required this.label,
    required this.color,
    super.key,
  });

  final String icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 20.sp,
          height: 20.sp,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        8.pw,
        Text(
          label,
          style: context.bodyLargeStyle?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryWhite,
          ),
        ),
      ],
    );
  }
}
