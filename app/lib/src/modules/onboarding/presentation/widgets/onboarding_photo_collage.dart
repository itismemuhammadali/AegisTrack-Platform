import '../../../../core/utils/app_exports.dart';

class _CollageTile {
  const _CollageTile(this.asset, this.left, this.top, this.width, this.height);

  final String asset;
  final double left;
  final double top;
  final double width;
  final double height;
}

// Top offsets are the Figma frame's local values (relative to the text
// container, which starts 84px below the page's top edge) shifted by that
// +84px so they're relative to the page's top-left instead. That matches
// how Figma renders this group: the tiles bleed above the frame's own top
// edge and are clipped by the page bounds, not confined to a small box
// above the title.
const _tiles = [
  _CollageTile(AppAssetsPng.onboardingAddProofTile1, 163.5, 54.01, 113, 181),
  _CollageTile(AppAssetsPng.onboardingAddProofTile2, 23.5, 426.01, 113, 181),
  _CollageTile(AppAssetsPng.onboardingAddProofTile3, 23.5, -44.99, 113, 181),
  _CollageTile(AppAssetsPng.onboardingAddProofTile4, 303.5, 190, 113, 181),
  _CollageTile(AppAssetsPng.onboardingAddProofTile5, 23.5, 152.01, 113, 258),
  _CollageTile(AppAssetsPng.onboardingAddProofTile6, 163.5, 251.01, 113, 258),
  _CollageTile(AppAssetsPng.onboardingAddProofTile7, 303.5, 388, 113, 258),
  _CollageTile(AppAssetsPng.onboardingAddProofTile8, 303, -83, 113, 258),
  _CollageTile(AppAssetsPng.onboardingAddProofTile9, 163.5, -219.99, 113, 258),
];

/// Full-bleed scattered grid of rounded photo tiles behind the "Add Proof to
/// Every Log" onboarding page. Tile positions are lifted directly from the
/// Figma frame (440x956 design space) so they line up with [AppSize]'s
/// ScreenUtil scaling without any extra math. Meant to be painted as a
/// full-screen [OnboardingPageScaffold.foreground] layer — several tiles
/// intentionally sit above y=0 and are clipped by the page's own bounds,
/// exactly as in Figma.
class OnboardingPhotoCollage extends StatelessWidget {
  const OnboardingPhotoCollage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        for (final tile in _tiles)
          Positioned(
            left: tile.left.w,
            top: tile.top.h,
            width: tile.width.w,
            height: tile.height.h,
            child: ClipRRect(
              borderRadius: 170.circular,
              child: Image.asset(tile.asset, fit: BoxFit.cover),
            ),
          ),
      ],
    );
  }
}
