import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracked_anti_spoof_check_entity.dart';

enum TrackedAntiSpoofCheckState { pending, active, passed }

class TrackedAntiSpoofCheckRow extends StatelessWidget {
  const TrackedAntiSpoofCheckRow({
    super.key,
    required this.check,
    required this.state,
  });

  final TrackedAntiSpoofCheckEntity check;
  final TrackedAntiSpoofCheckState state;

  @override
  Widget build(BuildContext context) {
    const green = AppColors.trackedZoneAllowedGreen;
    final passed = state == TrackedAntiSpoofCheckState.passed;
    final active = state == TrackedAntiSpoofCheckState.active;

    return Container(
      padding: AppInsets.all(16),
      decoration: BoxDecoration(
        color: passed
            ? green.withValues(alpha: 0.1)
            : AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 16.circular,
        border: Border.all(
          color: AppColors.primaryWhite.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: passed
                  ? green.withValues(alpha: 0.09)
                  : (active ? AppColors.signInDarkSubtitle : AppColors.hintGray)
                      .withValues(alpha: 0.09),
              borderRadius: 18.circular,
            ),
            child: switch (state) {
              TrackedAntiSpoofCheckState.active => SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryWhite.withValues(alpha: 0.6),
                    backgroundColor:
                        AppColors.primaryWhite.withValues(alpha: 0.2),
                  ),
                ),
              _ => SvgPicture.asset(
                  check.icon,
                  width: 20.w,
                  height: 20.w,
                  // Icons ship gray (pending) — tint green once passed.
                  colorFilter: passed
                      ? const ColorFilter.mode(green, BlendMode.srcIn)
                      : null,
                ),
            },
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  check.title,
                  style: context.bodyMediumStyle?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 17.5 / 14,
                    color: AppColors.primaryWhite,
                  ),
                ),
                2.ph,
                Text(
                  active ? AppStrings.antiSpoofAnalyzing : check.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    height: 16 / 12,
                    color: AppColors.hintGray,
                  ),
                ),
              ],
            ),
          ),
          if (passed) ...[
            8.pw,
            Text(
              '${check.score}%',
              style: context.bodySmallStyle?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                height: 16 / 12,
                color: green,
              ),
            ),
            8.pw,
            SvgPicture.asset(
              AppAssetsSvg.trackedAntiSpoofPassed,
              width: 20.w,
              height: 20.w,
            ),
          ],
        ],
      ),
    );
  }
}
