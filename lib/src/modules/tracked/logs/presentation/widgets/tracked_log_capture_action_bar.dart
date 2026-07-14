import '../../../../../core/utils/app_exports.dart';

class TrackedLogCaptureActionBar extends StatelessWidget {
  const TrackedLogCaptureActionBar({super.key, required this.onCapture});

  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112.h,
      width: double.infinity,
      child: ClipRect(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            OverflowBox(
              alignment: Alignment.topCenter,
              minWidth: 0,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: double.infinity,
              child: Container(
                width: 1192.w,
                height: 1192.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.trackedBottomBarArc.withValues(alpha: 0.8),
                ),
              ),
            ),
            Positioned(
              top: 35.h,
              left: 24.w,
              right: 24.w,
              child: PrimaryAppButton(
                text: AppStrings.trackedLogCaptureButton,
                onTap: onCapture,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
