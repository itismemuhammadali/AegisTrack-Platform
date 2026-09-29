import '../../../../../core/utils/app_exports.dart';

class TrackedAiHeader extends StatelessWidget {
  const TrackedAiHeader({super.key, this.onBack});

  /// Shown only while searching / showing results (Figma).
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final content = Column(
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

    if (onBack == null) return content;
    return Row(
      children: [
        AppBackButton(onTap: onBack),
        16.pw,
        Expanded(child: content),
      ],
    );
  }
}
