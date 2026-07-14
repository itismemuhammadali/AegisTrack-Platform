import '../../../../../core/utils/app_exports.dart';

class QuickActionButton extends StatelessWidget {
  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.isPrimary = false,
    this.onTap,
  });

  final String icon;
  final String label;
  final bool isPrimary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: AppInsets.all(17),
        decoration: BoxDecoration(
          color: isPrimary ? null : AppColors.primaryWhite.withValues(
            alpha: 0.05,
          ),
          gradient: isPrimary
              ? LinearGradient(
                  colors: AppColors.onboardingButtonGradientColors,
                  stops: AppColors.onboardingButtonGradientStops,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          borderRadius: 16.circular,
          border: Border.all(
            color: AppColors.primaryWhite.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              width: 24.sp,
              height: 24.sp,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryWhite,
                BlendMode.srcIn,
              ),
            ),
            12.ph,
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.labelSmallStyle?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
