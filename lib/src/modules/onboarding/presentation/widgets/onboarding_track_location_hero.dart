import '../../../../core/utils/app_exports.dart';

/// "Track Your Location Securely" hero graphic: a frosted-glass circle over
/// the purple location blob. Figma bakes the blurred blob as a raster image
/// masked into the circle (`<mask>`+`<pattern>`) — `flutter_svg`
/// (vector_graphics_compiler) doesn't support that combination, so it was
/// dropped from [AppAssetsSvg.onboardingTrackLocationBlob] (which now only
/// keeps the small accent-drop paths that render correctly) and rebuilt
/// here: the same blurred-blob raster the export embedded, clipped to the
/// circle, with the glass sheen/rim gradient — matching Figma's
/// `paint4`/`paint5` — layered on top.
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
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    left: -8.4.w,
                    top: 31.22.h,
                    width: 222.w,
                    height: 223.h,
                    child: Image.asset(
                      AppAssetsPng.onboardingTrackLocationBlobBlur,
                      fit: BoxFit.fill,
                    ),
                  ),
                  DecoratedBox(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
