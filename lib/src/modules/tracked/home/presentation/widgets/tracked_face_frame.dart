import '../../../../../core/utils/app_exports.dart';

/// Camera frame with corner brackets, an optional top badge and hint, and a
/// dashed face oval — or the captured [photo] inside the oval.
class TrackedFaceFrame extends StatelessWidget {
  const TrackedFaceFrame({super.key, this.topBadge, this.hint, this.photo});

  final Widget? topBadge;
  final String? hint;
  final File? photo;

  @override
  Widget build(BuildContext context) {
    final captured = photo != null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: 24.circular,
        border: Border.all(
          color: AppColors.primaryWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!captured) ...[
            for (final alignment in const [
              Alignment.topLeft,
              Alignment.topRight,
              Alignment.bottomLeft,
              Alignment.bottomRight,
            ])
              Positioned.fill(
                child: Padding(
                  padding: AppInsets.all(16),
                  child: Align(
                    alignment: alignment,
                    child: _CornerBracket(alignment: alignment),
                  ),
                ),
              ),
            if (topBadge != null) Positioned(top: 16.h, child: topBadge!),
            if (hint != null)
              Positioned(
                bottom: 24.h,
                child: Text(
                  hint!,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    height: 16 / 12,
                    color: AppColors.primaryWhite.withValues(alpha: 0.6),
                  ),
                ),
              ),
          ],
          _FaceOval(photo: photo),
        ],
      ),
    );
  }
}

class _FaceOval extends StatelessWidget {
  const _FaceOval({required this.photo});

  final File? photo;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(87.6.w);

    return SizedBox(
      width: 160.w,
      height: 192.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (photo != null) ...[
            Positioned.fill(
              child: ClipRRect(
                borderRadius: radius,
                child: Image.file(photo!, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              right: -8.w,
              top: -8.w,
              child: Container(
                width: 32.w,
                height: 32.w,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.trackedZoneAllowedGreen,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppAssetsSvg.trackedSelfieCapturedCheck,
                  width: 16.w,
                  height: 16.w,
                ),
              ),
            ),
          ] else ...[
            Positioned.fill(
              child: CustomPaint(
                painter: _DashedOvalPainter(
                  radius: 87.6.w,
                  color: AppColors.primaryWhite.withValues(alpha: 0.3),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryWhite.withValues(alpha: 0.1),
                    ),
                  ),
                  8.ph,
                  Container(
                    width: 96.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      borderRadius: 100.circular,
                      color: AppColors.primaryWhite.withValues(alpha: 0.05),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -4.w,
              left: 76.w,
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      AppColors.trackedZoneAllowedGreen.withValues(alpha: 0.53),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DashedOvalPainter extends CustomPainter {
  _DashedOvalPainter({required this.radius, required this.color});

  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 3), paint);
        distance += 6;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedOvalPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}

class _CornerBracket extends StatelessWidget {
  const _CornerBracket({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final side = BorderSide(
      color: AppColors.primaryWhite.withValues(alpha: 0.5),
    );
    final top = alignment.y < 0;
    final left = alignment.x < 0;
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        border: Border(
          top: top ? side : BorderSide.none,
          bottom: top ? BorderSide.none : side,
          left: left ? side : BorderSide.none,
          right: left ? BorderSide.none : side,
        ),
        borderRadius: BorderRadius.only(
          topLeft: top && left ? const Radius.circular(4) : Radius.zero,
          topRight: top && !left ? const Radius.circular(4) : Radius.zero,
          bottomLeft: !top && left ? const Radius.circular(4) : Radius.zero,
          bottomRight: !top && !left ? const Radius.circular(4) : Radius.zero,
        ),
      ),
    );
  }
}
