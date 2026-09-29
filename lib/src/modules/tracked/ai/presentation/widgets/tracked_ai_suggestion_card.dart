import '../../../../../core/utils/app_exports.dart';

class TrackedAiSuggestionCard extends StatelessWidget {
  const TrackedAiSuggestionCard({super.key, required this.query, this.onTap});

  final String query;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite.withValues(alpha: 0.05),
          borderRadius: 16.circular,
          border: Border.all(
            color: AppColors.primaryWhite.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              AppAssetsSvg.trackedAiQuerySparkle,
              width: 16.w,
              height: 16.w,
            ),
            12.pw,
            Expanded(
              child: Text(
                query,
                style: context.bodyMediumStyle?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 20 / 14,
                  color: AppColors.signInDarkSubtitle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
