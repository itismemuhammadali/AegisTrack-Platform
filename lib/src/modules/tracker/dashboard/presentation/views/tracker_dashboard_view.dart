import '../../../../../core/utils/app_exports.dart';
import '../controller/tracker_dashboard_controller.dart';
import '../widgets/tracker_bottom_bar.dart';

class TrackerDashboardView extends ConsumerWidget {
  const TrackerDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerDashboardControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.trackedDashboardBackground,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 0.5, 1],
            colors: [
              AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
              AppColors.onboardingScrimNavy.withValues(alpha: 0.9),
              AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  padding: MediaQuery.paddingOf(context).copyWith(
                    bottom: TrackerBottomBar.heightOf(context),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: IndexedStack(
                    index: controller.selectedIndex,
                    children: controller.screens,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: TrackerBottomBar(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}
