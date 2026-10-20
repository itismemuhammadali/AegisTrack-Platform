import '../../../../../core/utils/app_exports.dart';
import 'tracked_settings_toggle.dart';

class TrackedSettingsToggleRow extends StatelessWidget {
  const TrackedSettingsToggleRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.onboardingButtonGradientColors,
                stops: AppColors.onboardingButtonGradientStops,
              ),
            ),
            child: SvgPicture.asset(icon, width: 20.sp, height: 20.sp),
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.bodyMediumStyle?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryWhite,
                  ),
                ),
                2.ph,
                Text(
                  subtitle,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.trackedSettingsMutedText,
                  ),
                ),
              ],
            ),
          ),
          12.pw,
          TrackedSettingsToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
