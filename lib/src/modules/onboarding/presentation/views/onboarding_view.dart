import '../../../../core/utils/app_exports.dart';
import '../controller/onboarding_controller.dart';
import '../widgets/onboarding_next_button.dart';
import '../widgets/onboarding_page_indicator.dart';
import '../widgets/onboarding_page_scaffold.dart';

class OnboardingView extends HookConsumerWidget {
  const OnboardingView({super.key, this.onGetStarted});

  final VoidCallback? onGetStarted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final controller = ref.watch(onboardingControllerProvider);
    final pages = controller.pages;
    final background = controller.pageBackgrounds[controller.currentPage];
    final isLastPage = controller.isLastPage;

    return Scaffold(
      backgroundColor: AppColors.onboardingScrimNavy,
      body: Stack(
        children: [
          // Figma paints the background full-bleed behind the whole page,
          // including behind the indicator/button strip below — which lives
          // outside the PageView so it can stay put across page swipes.
          // This underlay keeps that area visually consistent with the
          // current page instead of falling back to flat navy.
          Positioned.fill(
            child: OnboardingPageBackground(
              backgroundAsset: background.backgroundAsset,
              bottomFade: background.bottomFade,
            ),
          ),
          Column(
            children: [
              // Each page bottom-aligns its own title/subtitle within this
              // area, so the indicator + button below must sit in their own
              // reserved space rather than overlay the page content directly
              // (per Figma, page content + dots + button are stacked in one
              // flex column, not layered on top of each other).
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: controller.setPage,
                  children: pages,
                ),
              ),
              24.ph,
              OnboardingPageIndicator(
                pageCount: pages.length,
                currentPage: controller.currentPage,
              ),
              24.ph,
              Padding(
                padding: AppInsets.symmetric(horizontal: 24),
                child: OnboardingNextButton(
                  text: isLastPage ? AppStrings.getStarted : AppStrings.next,
                  onTap: () {
                    if (isLastPage) {
                      onGetStarted?.call();
                    } else {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                ),
              ),
              SafeArea(top: false, child: SizedBox(height: 32.h)),
            ],
          ),
        ],
      ),
    );
  }
}
