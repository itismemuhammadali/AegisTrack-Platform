import '../../../../../core/utils/app_exports.dart';

/// Figma bottom action strip: 112px tall, top of a 1192px navy ellipse,
/// with the action(s) placed 42px from the top and 24px from the sides.
class TrackedArcActionBar extends StatelessWidget {
  const TrackedArcActionBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112.h,
      width: double.infinity,
      child: ClipRect(
        child: Stack(
          children: [
            OverflowBox(
              alignment: Alignment.topCenter,
              minWidth: 0,
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: SvgPicture.asset(
                AppAssetsSvg.trackedSosBottomArc,
                width: 1192.w,
                height: 596.w,
              ),
            ),
            Positioned(
              top: 42.h,
              left: 24.w,
              right: 24.w,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

/// Primary (purple gradient) or secondary (glass) button used on the
/// arc action bar.
class TrackedArcButton extends StatelessWidget {
  const TrackedArcButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.isPrimary = true,
  });

  final String label;
  final VoidCallback? onTap;
  final String? icon;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Container(
          padding: AppInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isPrimary
                ? null
                : AppColors.primaryWhite.withValues(alpha: 0.05),
            gradient: isPrimary
                ? const LinearGradient(
                    colors: AppColors.trackedQuickActionGradientColors,
                  )
                : null,
            borderRadius: 16.circular,
            border: isPrimary
                ? null
                : Border.all(
                    color: AppColors.primaryWhite.withValues(alpha: 0.1),
                  ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: AppColors.twoFactorAccentPurple
                          .withValues(alpha: 0.3),
                      blurRadius: 3,
                      offset: Offset(0, 4.h),
                    ),
                    BoxShadow(
                      color: AppColors.twoFactorAccentPurple
                          .withValues(alpha: 0.3),
                      blurRadius: 7.5,
                      offset: Offset(0, 10.h),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                SvgPicture.asset(icon!, width: 16.w, height: 16.w),
                8.pw,
              ],
              Text(
                label,
                style: context.bodyLargeStyle?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
                  height: 24 / 16,
                  color: AppColors.primaryWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
