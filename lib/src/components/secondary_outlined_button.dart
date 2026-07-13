import '../core/utils/app_exports.dart';

class SecondaryOutlinedButton extends StatelessWidget {
  const SecondaryOutlinedButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.isDark,
    required this.textColor,
  });

  final VoidCallback onTap;
  final String text;
  final bool isDark;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: AppInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.travellerBorder.withValues(alpha: 0.3)
              : AppColors.signInLightText.withValues(alpha: 0.3),
          borderRadius: 10.circular,
          border: Border.all(
            color: isDark
                ? AppColors.travellerBorder
                : AppColors.signInLightText.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          text,
          style: context.labelLargeStyle?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
