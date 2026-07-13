import '../../../../core/utils/app_exports.dart';
import '../widgets/onboarding_page_scaffold.dart';
import '../widgets/onboarding_photo_collage.dart';

class OnboardingController extends ChangeNotifier with Buffers {
  int currentPage = 0;

  // Background metadata mirrors each entry in [pages] below. [OnboardingView]
  // uses this to paint a full-bleed underlay for the current page behind the
  // shared page-indicator/button strip, which sits outside each page's own
  // scaffold (see OnboardingPageBackground doc comment for why).
  List<({String? backgroundAsset, bool bottomFade})> get pageBackgrounds => [
    (backgroundAsset: AppAssetsPng.onboardingTrackLocationBg, bottomFade: false),
    (backgroundAsset: AppAssetsPng.onboardingAddProofBg, bottomFade: false),
    (backgroundAsset: AppAssetsPng.onboardingStaySyncedBg, bottomFade: true),
  ];

  List<Widget> get pages => [
    OnboardingPageScaffold(
      backgroundAsset: AppAssetsPng.onboardingTrackLocationBg,
      title: AppStrings.onboardingTrackLocationTitle,
      subtitle: AppStrings.onboardingTrackLocationSubtitle,
      // Figma's hero graphic (the glowing pin, "Layer 2") renders at
      // 211x248 including its glow bleed — this SVG was exported at that
      // same size, so its height must match or the whole hero visibly
      // shrinks and throws off its position above the title.
      hero: SvgPicture.asset(AppAssetsSvg.onboardingTrackLocationHero, height: 247.h),
    ),
    OnboardingPageScaffold(
      backgroundAsset: AppAssetsPng.onboardingAddProofBg,
      title: AppStrings.onboardingAddProofTitle,
      subtitle: AppStrings.onboardingAddProofSubtitle,
      foreground: const OnboardingPhotoCollage(),
    ),
    OnboardingPageScaffold(
      backgroundAsset: AppAssetsPng.onboardingStaySyncedBg,
      title: AppStrings.onboardingStaySyncedTitle,
      subtitle: AppStrings.onboardingStaySyncedSubtitle,
      bottomFade: true,
    ),
  ];

  bool get isLastPage => currentPage == pages.length - 1;

  void setPage(int index) {
    if (currentPage == index) return;
    currentPage = index;
    notifyListeners();
  }
}

final onboardingControllerProvider = ChangeNotifierProvider<OnboardingController>(
  (ref) => OnboardingController(),
);
