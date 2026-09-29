import '../../../../../core/utils/app_exports.dart';

/// Pill-shaped on/off switch for tracking preference rows — gradient track
/// when enabled, translucent white track when disabled, per Figma.
class TrackedSettingsToggle extends StatelessWidget {
  const TrackedSettingsToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48.w,
        height: 24.h,
        padding: EdgeInsets.all(2.w),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: value ? null : AppColors.primaryWhite.withValues(alpha: 0.1),
          gradient: value
              ? LinearGradient(
                  colors: AppColors.onboardingButtonGradientColors,
                  stops: AppColors.onboardingButtonGradientStops,
                )
              : null,
          borderRadius: 999.circular,
        ),
        child: Container(
          width: 20.w,
          height: 20.w,
          decoration: const BoxDecoration(
            color: AppColors.primaryWhite,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.authToggleShadow,
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
