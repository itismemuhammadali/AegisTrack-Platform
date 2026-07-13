import '../../../../core/utils/app_exports.dart';
import '../widgets/onboarding_page_scaffold.dart';
import '../widgets/onboarding_photo_collage.dart';
import '../widgets/onboarding_track_location_hero.dart';

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
      title: AppStrings.onboardingTrackLocationTitle,
      subtitle: AppStrings.onboardingTrackLocationSubtitle,
      hero: const OnboardingTrackLocationHero(),
    ),
    OnboardingPageScaffold(
      title: AppStrings.onboardingAddProofTitle,
      subtitle: AppStrings.onboardingAddProofSubtitle,
      foreground: const OnboardingPhotoCollage(),
    ),
    OnboardingPageScaffold(
      title: AppStrings.onboardingStaySyncedTitle,
      subtitle: AppStrings.onboardingStaySyncedSubtitle,
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
