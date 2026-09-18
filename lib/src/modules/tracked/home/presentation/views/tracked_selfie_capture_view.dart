import '../../../../../core/utils/app_exports.dart';
import '../../../authentication/presentation/widgets/tracked_subscription_scaffold.dart';
import '../controller/tracked_home_controller.dart';
import '../widgets/tracked_arc_action_bar.dart';

class TrackedSelfieCaptureView extends ConsumerWidget {
  const TrackedSelfieCaptureView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedHomeControllerProvider);
    final selfie = controller.selfie;

    return TrackedSubscriptionScaffold(
      title: AppStrings.selfieTitle,
      subtitle: AppStrings.selfieSubtitle,
      subtitleColor: AppColors.primaryWhite.withValues(alpha: 0.6),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: AppInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: selfie == null ? 32 : 24,
              ),
              child: Column(
                children: [
                  Expanded(child: _CameraFrame(selfie: selfie)),
                  24.ph,
                  const _QualityChips(),
                  24.ph,
                  _ShutterButton(onTap: controller.captureSelfie),
                ],
              ),
            ),
          ),
          if (selfie != null)
            TrackedArcActionBar(
              child: Row(
                children: [
                  Expanded(
                    child: TrackedArcButton(
                      label: AppStrings.selfieRetake,
                      icon: AppAssetsSvg.trackedSelfieRetake,
                      isPrimary: false,
                      onTap: controller.retakeSelfie,
                    ),
                  ),
                  16.pw,
                  Expanded(
                    child: TrackedArcButton(
                      label: AppStrings.selfieConfirmCheckIn,
                      icon: AppAssetsSvg.trackedSelfieConfirm,
                      onTap: () {
                        controller.confirmCheckIn();
                        AppRouterGo.pushReplacement(trackedCheckInCompleteView);
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CameraFrame extends StatelessWidget {
  const _CameraFrame({required this.selfie});

  final File? selfie;

  @override
  Widget build(BuildContext context) {
    final captured = selfie != null;

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
            Positioned(top: 16.h, child: const _GoodLightPill()),
            Positioned(
              bottom: 24.h,
              child: Text(
                AppStrings.selfiePositionFace,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  height: 16 / 12,
                  color: AppColors.primaryWhite.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
          _FaceOval(selfie: selfie),
        ],
      ),
    );
  }
}

class _FaceOval extends StatelessWidget {
  const _FaceOval({required this.selfie});

  final File? selfie;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(87.6.w);

    return SizedBox(
      width: 160.w,
      height: 192.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (selfie != null) ...[
            Positioned.fill(
              child: ClipRRect(
                borderRadius: radius,
                child: Image.file(selfie!, fit: BoxFit.cover),
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

class _GoodLightPill extends StatelessWidget {
  const _GoodLightPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryblack.withValues(alpha: 0.5),
        borderRadius: 100.circular,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppAssetsSvg.trackedSelfieLight,
            width: 12.w,
            height: 12.w,
          ),
          6.pw,
          Text(
            AppStrings.selfieGoodLight,
            style: context.bodySmallStyle?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
              color: AppColors.trackedZoneAllowedGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _QualityChips extends StatelessWidget {
  const _QualityChips();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final label in const [
          AppStrings.selfieAutoFlash,
          AppStrings.selfieSharp,
          AppStrings.selfieGoodLight,
        ]) ...[
          Container(
            padding: AppInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite.withValues(alpha: 0.05),
              borderRadius: 18.circular,
              border: Border.all(
                color: AppColors.primaryWhite.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: const BoxDecoration(
                    color: AppColors.trackedZoneAllowedGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                6.pw,
                Text(
                  label,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    height: 16 / 12,
                    color: AppColors.signInDarkSubtitle,
                  ),
                ),
              ],
            ),
          ),
          8.pw,
        ],
      ],
    );
  }
}

class _ShutterButton extends StatelessWidget {
  const _ShutterButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64.w,
        height: 64.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryWhite.withValues(alpha: 0.2),
              blurRadius: 3,
              offset: Offset(0, 4.h),
            ),
            BoxShadow(
              color: AppColors.primaryWhite.withValues(alpha: 0.2),
              blurRadius: 7.5,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Container(
          width: 48.w,
          height: 48.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.trackedCheckInStartText),
          ),
          child: SvgPicture.asset(
            AppAssetsSvg.trackedSelfieShutter,
            width: 24.w,
            height: 24.w,
          ),
        ),
      ),
    );
  }
}
