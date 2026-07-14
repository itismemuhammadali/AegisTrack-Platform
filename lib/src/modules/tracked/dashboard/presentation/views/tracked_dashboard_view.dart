import '../../../../../core/utils/app_exports.dart';
import '../controller/tracked_dashboard_controller.dart';
import '../widgets/tracked_bottom_bar.dart';

class TrackedDashboardView extends ConsumerWidget {
  const TrackedDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedDashboardControllerProvider);

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
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned.fill(
                child: IndexedStack(
                  index: controller.selectedIndex,
                  children: controller.screens,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: TrackedBottomBar(controller: controller),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
