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
        child: Column(
          children: [
            Expanded(
              child: SafeArea(
                bottom: false,
                child: IndexedStack(
                  index: controller.selectedIndex,
                  children: controller.screens,
                ),
              ),
            ),
            TrackerBottomBar(controller: controller),
          ],
        ),
      ),
    );
  }
}
