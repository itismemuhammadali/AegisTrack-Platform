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
        height: 80.h,
        padding: AppInsets.all(12),
        decoration: BoxDecoration(
          color:
              isPrimary ? null : AppColors.primaryWhite.withValues(alpha: 0.05),
          gradient: isPrimary
              ? const LinearGradient(
                  colors: AppColors.trackedQuickActionGradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: 16.circular,
          border: Border.all(
            color: AppColors.primaryWhite.withValues(alpha: 0.1),
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppColors.trackedQuickActionShadow,
                    blurRadius: 3,
                    offset: Offset(0, 4.h),
                  ),
                  BoxShadow(
                    color: AppColors.trackedQuickActionShadow,
                    blurRadius: 7.5,
                    offset: Offset(0, 10.h),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, width: 20.w, height: 20.w),
            8.ph,
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.labelSmallStyle?.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                height: 15 / 10,
                color: AppColors.primaryWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
