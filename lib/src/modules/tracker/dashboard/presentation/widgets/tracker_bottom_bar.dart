import '../../../../../core/utils/app_exports.dart';
import '../controller/tracker_dashboard_controller.dart';

/// Curved navy bar with four tabs; the selected tab sits on a purple tile.
class TrackerBottomBar extends StatelessWidget {
  const TrackerBottomBar({super.key, required this.controller});

  final TrackerDashboardController controller;

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
                AppAssetsSvg.trackerBottomArc,
                width: 1192.w,
                height: 596.w,
              ),
            ),
            Positioned(
              top: 37.h,
              left: 40.w,
              right: 40.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(controller.tabs.length, (i) {
                  final selected = controller.isSelected(i);
                  final tab = controller.tabs[i];
                  final color = selected
                      ? AppColors.primaryWhite
                      : AppColors.primaryWhite.withValues(alpha: 0.6);

                  return GestureDetector(
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
                                    colors: AppColors
                                        .onboardingButtonGradientColors,
                                    stops:
                                        AppColors.onboardingButtonGradientStops,
                                  )
                                : null,
                          ),
                          child: SvgPicture.asset(
                            tab.icon,
                            width: 24.w,
                            height: 24.w,
                            colorFilter:
                                ColorFilter.mode(color, BlendMode.srcIn),
                          ),
                        ),
                        4.ph,
                        Text(
                          tab.label,
                          style: context.bodySmallStyle?.copyWith(
                            fontSize: 12.sp,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w500,
                            height: 16 / 12,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
