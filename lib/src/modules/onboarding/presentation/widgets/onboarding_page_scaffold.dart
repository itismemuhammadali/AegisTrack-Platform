import '../../../../core/utils/app_exports.dart';

/// Full-bleed background image (or flat navy fallback) plus the dark scrim
/// that keeps white text readable. Figma paints this behind the entire page
/// — including the area behind the shared page-indicator/button strip below
/// the `PageView` — so [OnboardingView] renders one of these per the current
/// page as a screen-wide underlay in addition to the copy each
/// [OnboardingPageScaffold] paints behind its own content.
class OnboardingPageBackground extends StatelessWidget {
  const OnboardingPageBackground({
    super.key,
    this.backgroundAsset,
    this.bottomFade = false,
  });

  final String? backgroundAsset;

  /// Figma treats the last ("Stay Synced Anywhere") page with a simple
  /// top-to-bottom fade instead of the diagonal vignette + flat wash used on
  /// the other two pages.
  final bool bottomFade;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (backgroundAsset != null)
          Image.asset(backgroundAsset!, fit: BoxFit.cover)
        else
          Container(color: AppColors.onboardingScrimNavy),
        DecoratedBox(decoration: BoxDecoration(gradient: _overlayGradient)),
        if (!bottomFade) Container(color: AppColors.onboardingScrimWash),
      ],
    );
  }

  Gradient get _overlayGradient => bottomFade
      ? LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
            AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
            AppColors.onboardingScrimNavy,
          ],
          stops: const [0, 0.62, 1],
        )
      : LinearGradient(
          begin: const Alignment(-0.85, -0.45),
          end: const Alignment(0.85, 0.45),
          colors: [
            AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
            AppColors.onboardingScrimNavy.withValues(alpha: 0.9),
            AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
          ],
        );
}

/// Shared visual frame for an onboarding page: an optional full-bleed
/// foreground layer (drawn above the scrim, e.g. the photo collage), an
/// optional hero graphic, then the title/subtitle stacked above it.
///
/// The page's own background is painted once by [OnboardingView]'s full-bleed
/// underlay (see that file's doc comment) rather than repainted here — this
/// widget only fills the `PageView`'s bounds, which are shorter than the full
/// screen, so a second copy of the same image scaled to that smaller box
/// doesn't line up with the underlay and shows as a visible seam.
class OnboardingPageScaffold extends StatelessWidget {
  const OnboardingPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    this.foreground,
    this.hero,
  });

  final String title;
  final String subtitle;

  /// Full-bleed layer painted above the scrim and behind the text, e.g.
  /// [OnboardingPhotoCollage] which bleeds above the frame's own top edge
  /// per the Figma layout (it is not confined to the text-column bounds).
  final Widget? foreground;
  final Widget? hero;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (foreground != null) foreground!,
        SafeArea(
          bottom: false,
          child: Padding(
            padding: AppInsets.only(left: 24, right: 24, bottom: 32),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (hero != null) ...[hero!, 160.ph],
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.headlineMediumStyle?.copyWith(
                    color: AppColors.primaryWhite,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                10.ph,
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: context.bodyLargeStyle?.copyWith(
                    color: AppColors.signInDarkSubtitle,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    height: 26 / 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
