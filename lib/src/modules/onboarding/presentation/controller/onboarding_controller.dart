import '../../../../core/utils/app_exports.dart';
import '../widgets/onboarding_page_scaffold.dart';
import '../widgets/onboarding_photo_collage.dart';

class OnboardingController extends ChangeNotifier with Buffers {
  int currentPage = 0;

  List<Widget> get pages => [
    OnboardingPageScaffold(
      backgroundAsset: AppAssetsPng.onboardingTrackLocationBg,
      title: AppStrings.onboardingTrackLocationTitle,
      subtitle: AppStrings.onboardingTrackLocationSubtitle,
      hero: Image.asset(AppAssetsPng.onboardingTrackLocationIcon, height: 180.h),
    ),
    const OnboardingPageScaffold(
      title: AppStrings.onboardingAddProofTitle,
      subtitle: AppStrings.onboardingAddProofSubtitle,
      foreground: OnboardingPhotoCollage(),
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
