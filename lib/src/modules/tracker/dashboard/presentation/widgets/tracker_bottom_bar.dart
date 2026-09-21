import '../../../../../core/utils/app_exports.dart';
import '../controller/tracker_dashboard_controller.dart';

/// Curved navy bar with four tabs; the selected tab sits on a purple tile.
class TrackerBottomBar extends StatelessWidget {
  const TrackerBottomBar({super.key, required this.controller});

  final TrackerDashboardController controller;

  // Keep the footer compact even on phones with a large home-indicator inset.
  static double _bottomSpacing(BuildContext context) =>
      MediaQuery.paddingOf(context).bottom.clamp(4.0, 12.0);

  static double heightOf(BuildContext context) =>
      37.h + 40.w + 4.h + 16.sp + _bottomSpacing(context);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightOf(context),
      width: double.infinity,
      child: ClipRect(
        child: Stack(
          children: [
            IgnorePointer(
                child: OverflowBox(
              alignment: Alignment.topCenter,
              minWidth: 0,
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: SvgPicture.asset(
                AppAssetsSvg.trackerBottomArc,
                width: 1192.w,
                height: 596.w,
              ),
            )),
            Positioned(
              bottom: _bottomSpacing(context),
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

                  return Semantics(
                    selected: selected,
                    button: true,
                    label: tab.label,
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
                                      colors: AppColors
                                          .onboardingButtonGradientColors,
                                      stops: AppColors
                                          .onboardingButtonGradientStops,
                                    )
                                  : null,
                            ),
                            child: _NavigationIcon(
                                index: i,
                                selected: selected,
                                fallback: tab.icon),
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

/// Figma exports retain their own opacity; tinting them again dims selection.
class _NavigationIcon extends StatelessWidget {
  const _NavigationIcon(
      {required this.index, required this.selected, required this.fallback});
  final int index;
  final bool selected;
  final String fallback;

  @override
  Widget build(BuildContext context) {
    if (index == 3 && selected) {
      return SizedBox(
          width: 24.w,
          height: 24.w,
          child: Stack(children: [
            Positioned(
                left: 4.25.w,
                top: 14.25.w,
                width: 15.5.w,
                height: 7.5.w,
                child: SvgPicture.asset(
                    'assets/icons/svg/tracker_nav_profile_active_body.svg')),
            Positioned(
                left: 7.25.w,
                top: 2.25.w,
                width: 9.5.w,
                height: 9.5.w,
                child: SvgPicture.asset(
                    'assets/icons/svg/tracker_nav_profile_active_head.svg')),
          ]));
    }
    final asset = switch (index) {
      1 when selected => 'assets/icons/svg/tracker_nav_users_active.svg',
      2 => selected
          ? 'assets/icons/svg/tracker_nav_cases_active.svg'
          : 'assets/icons/svg/tracker_nav_cases.svg',
      _ => fallback,
    };
    return SvgPicture.asset(asset,
        width: (index == 2 ? (selected ? 22.5 : 24.75) : 24).w,
        height: (index == 2 ? (selected ? 20 : 22) : 24).w,
        colorFilter: index == 0 && !selected
            ? const ColorFilter.mode(Color(0x99ffffff), BlendMode.srcIn)
            : null);
  }
}
