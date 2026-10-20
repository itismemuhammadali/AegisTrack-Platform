import 'package:joshua_r_hughes/src/components/shimmer_box.dart';

import '../core/utils/app_exports.dart';

class NetworkSnap extends StatelessWidget {
  final double? height, width, radius;
  final String? imageUrl;
  final String? imagePlaceHolder;
  final BoxFit? fit;
  final Color? color;
  final BorderRadiusGeometry? borderRadiusGeometry;
  final Widget Function(BuildContext, String, Object)? errorWidget;

  const NetworkSnap({
    super.key,
    this.fit,
    this.width,
    this.height,
    this.radius,
    this.imageUrl,
    this.color,
    this.imagePlaceHolder,
    this.errorWidget,
    this.borderRadiusGeometry,
  });

  @override
  Widget build(BuildContext context) {
    final double h = height ?? 34.sp;
    final double w = width ?? 34.sp;
    final BorderRadiusGeometry br =
        borderRadiusGeometry ?? BorderRadius.circular(radius ?? 10.r);

    // 1. If imageUrl is NULL, it's likely still loading from the API.
    // SHOW SHIMMER to prevent the logo flicker.
    if (imageUrl == null) {
      return ClipRRect(
        borderRadius: br,
        child: ShimmerBox(height: h, width: w),
      );
    }

    // 2. If imageUrl is EMPTY (""), we know there is no image to fetch.
    // SHOW LOGO immediately.
    if (imageUrl!.isEmpty) {
      return ClipRRect(borderRadius: br, child: _buildLogo(h, w));
    }

    // 3. If there is a URL string, attempt to load the image.
    return ClipRRect(
      borderRadius: br,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        height: h,
        width: w,
        color: color,
        fit: fit ?? BoxFit.cover,
        // Shows while downloading
        placeholder: (context, url) => ShimmerBox(height: h, width: w),
        // Shows if the URL is broken/404
        errorWidget: errorWidget ?? (context, url, error) => _buildLogo(h, w),
        fadeInDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  Widget _buildLogo(double h, double w) {
    return Container(
      height: h,
      width: w,
      padding: AppInsets.all(16.0),
      child: SvgPicture.asset(
        imagePlaceHolder ?? 'assets/logo/logo.png',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(AppColors.casper, BlendMode.srcIn),
      ),
    );
  }
}
