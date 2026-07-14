import '../../../../../core/utils/app_exports.dart';

/// Pill-shaped on/off switch used by the "Trust this device" row on the
/// two-factor screen — translucent track, white thumb, per Figma.
class TrustDeviceToggle extends StatelessWidget {
  const TrustDeviceToggle(
      {super.key, required this.value, required this.onChanged});

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
          color: value
              ? AppColors.twoFactorAccentPurple
              : AppColors.primaryWhite.withValues(alpha: 0.1),
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
