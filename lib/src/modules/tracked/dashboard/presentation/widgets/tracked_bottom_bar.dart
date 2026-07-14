import '../../../../../core/utils/app_exports.dart';
import '../controller/tracked_dashboard_controller.dart';

class TrackedBottomBar extends StatelessWidget {
  const TrackedBottomBar({super.key, required this.controller});

  final TrackedDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(controller.tabs.length, (i) {
          final selected = controller.isSelected(i);
          final tab = controller.tabs[i];
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => controller.onTabTapped(i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: 18.circular,
                    gradient: selected
                        ? LinearGradient(
                            colors: AppColors.onboardingButtonGradientColors,
                            stops: AppColors.onboardingButtonGradientStops,
                          )
                        : null,
                  ),
                  child: SvgPicture.asset(
                    tab.icon,
                    width: 24.sp,
                    height: 24.sp,
                    colorFilter: ColorFilter.mode(
                      selected ? AppColors.primaryWhite : AppColors.hintGray,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                4.ph,
                Text(
                  tab.label,
                  style: context.labelSmallStyle?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color:
                        selected ? AppColors.primaryWhite : AppColors.hintGray,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
