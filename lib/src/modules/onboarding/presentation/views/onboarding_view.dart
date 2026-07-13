import '../../../../core/utils/app_exports.dart';
import '../controller/onboarding_controller.dart';
import '../widgets/onboarding_next_button.dart';
import '../widgets/onboarding_page_indicator.dart';

class OnboardingView extends HookConsumerWidget {
  const OnboardingView({super.key, this.onGetStarted});

  final VoidCallback? onGetStarted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final controller = ref.watch(onboardingControllerProvider);
    final pages = controller.pages;
    final isLastPage = controller.isLastPage;

    return Scaffold(
      backgroundColor: AppColors.onboardingScrimNavy,
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: controller.setPage,
            children: pages,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: AppInsets.only(bottom: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OnboardingPageIndicator(
                      pageCount: pages.length,
                      currentPage: controller.currentPage,
                    ),
                    24.ph,
                    Padding(
                      padding: AppInsets.symmetric(horizontal: 24),
                      child: OnboardingNextButton(
                        text: isLastPage
                            ? AppStrings.getStarted
                            : AppStrings.next,
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
