import '../../../../core/utils/app_exports.dart';

class _CollageTile {
  const _CollageTile(this.asset, this.left, this.top, this.width, this.height);

  final String asset;
  final double left;
  final double top;
  final double width;
  final double height;
}

const _tiles = [
  _CollageTile(AppAssetsPng.onboardingAddProofTile1, 163.5, -29.99, 113, 181),
  _CollageTile(AppAssetsPng.onboardingAddProofTile2, 23.5, 342.01, 113, 181),
  _CollageTile(AppAssetsPng.onboardingAddProofTile3, 23.5, -128.99, 113, 181),
  _CollageTile(AppAssetsPng.onboardingAddProofTile4, 303.5, 106, 113, 181),
  _CollageTile(AppAssetsPng.onboardingAddProofTile5, 23.5, 68.01, 113, 258),
  _CollageTile(AppAssetsPng.onboardingAddProofTile6, 163.5, 167.01, 113, 258),
  _CollageTile(AppAssetsPng.onboardingAddProofTile7, 303.5, 304, 113, 258),
  _CollageTile(AppAssetsPng.onboardingAddProofTile8, 303, -167, 113, 258),
  _CollageTile(AppAssetsPng.onboardingAddProofTile9, 163.5, -303.99, 113, 258),
];

/// Scattered grid of rounded photo tiles used behind the "Add Proof to Every
/// Log" onboarding page. Tile positions are lifted directly from the Figma
/// frame (440x956 design space) so they line up with [AppSize]'s ScreenUtil
/// scaling without any extra math.
class OnboardingPhotoCollage extends StatelessWidget {
  const OnboardingPhotoCollage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
