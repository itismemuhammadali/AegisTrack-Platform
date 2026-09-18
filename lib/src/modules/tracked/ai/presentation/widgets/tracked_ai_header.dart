import '../../../../../core/utils/app_exports.dart';

class TrackedAiHeader extends StatelessWidget {
  const TrackedAiHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppStrings.trackedAiSearchTitle,
              style: context.titleLargeStyle?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                height: 28 / 20,
                color: AppColors.primaryWhite,
              ),
            ),
            8.pw,
            Container(
              padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.twoFactorAccentPurple.withValues(alpha: 0.4),
                borderRadius: 100.circular,
                border: Border.all(color: AppColors.twoFactorAccentPurple),
              ),
              child: Text(
                AppStrings.trackedAiBeta,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  height: 16 / 12,
                  color: AppColors.primaryWhite,
                ),
              ),
            ),
          ],
        ),
        Text(
          AppStrings.trackedAiSearchSubtitle,
          style: context.bodyMediumStyle?.copyWith(
            fontSize: 14.sp,
            height: 20 / 14,
            color: AppColors.signInDarkSubtitle,
          ),
        ),
      ],
    );
  }
}
