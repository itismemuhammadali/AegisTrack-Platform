import 'dart:ui';

import '../../../../core/utils/app_exports.dart';

/// "Track Your Location Securely" hero graphic: a frosted-glass circle over
/// the purple location blob. Figma's export relies on a masked pattern fill
/// plus SVG filters for the glass — `flutter_svg` (vector_graphics_compiler)
/// doesn't support `<mask>`+`<pattern>` combined with `<filter>`, so that
/// circle rendered as a flat gray disc with a stray artifact above it
/// instead of showing the blob through frosted glass. Rebuilt natively: the
/// blob renders from its own (working) SVG, and a real [BackdropFilter]
/// blurs it — and whatever's behind the page — through a [ClipOval], which
/// reproduces the glass effect more faithfully than a static export could.
class OnboardingTrackLocationHero extends StatelessWidget {
  const OnboardingTrackLocationHero({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 211.w,
      height: 248.h,
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(AppAssetsSvg.onboardingTrackLocationBlob),
          ),
          Positioned(
            left: 11.w,
            top: 8.h,
            width: 180.22.w,
            height: 180.22.h,
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Colors.white.withValues(alpha: 0),
                        Colors.white.withValues(alpha: 0.06),
                        Colors.white.withValues(alpha: 0.14),
                        Colors.white.withValues(alpha: 0.25),
                        Colors.white.withValues(alpha: 0.4),
                      ],
                      stops: const [0, 0.33, 0.5, 0.66, 0.84],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.45),
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
