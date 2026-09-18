import '../../../../../core/utils/app_exports.dart';
import '../controller/tracked_dashboard_controller.dart';

class TrackedBottomBar extends StatelessWidget {
  const TrackedBottomBar({super.key, required this.controller});

  final TrackedDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.trackedBottomBarArc,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: AppInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: List.generate(controller.tabs.length, (i) {
              final selected = controller.isSelected(i);
              final tab = controller.tabs[i];
              final color = selected
                  ? AppColors.primaryWhite
                  : AppColors.primaryWhite.withValues(alpha: 0.6);
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.onTabTapped(i),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: 18.circular,
                          gradient: selected
                              ? const LinearGradient(
                                  colors:
                                      AppColors.onboardingButtonGradientColors,
                                  stops:
                                      AppColors.onboardingButtonGradientStops,
                                )
                              : null,
                        ),
                        child: SvgPicture.asset(
                          tab.icon,
                          width: 24.w,
                          height: 24.w,
                          colorFilter: ColorFilter.mode(
                            color,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      4.ph,
                      Text(
                        tab.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodyMediumStyle?.copyWith(
                          fontSize: 14.sp,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w500,
                          height: 18 / 14,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
