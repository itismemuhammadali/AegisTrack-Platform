import '../../../../../core/utils/app_exports.dart';

class TrackedHomeHeader extends StatelessWidget {
  const TrackedHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.joshuaRHughes,
          style: context.headlineSmallStyle?.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryWhite,
          ),
        ),
        2.ph,
        Row(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.trackedTrackingActiveGreen.withValues(
                  alpha: 0.5,
                ),
              ),
            ),
            8.pw,
            Text(
              AppStrings.trackingActive,
              style: context.bodyMediumStyle?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.trackedTrackingActiveGreen,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
