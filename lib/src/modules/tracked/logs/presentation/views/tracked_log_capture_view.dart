import '../../../../../core/utils/app_exports.dart';
import '../widgets/tracked_log_capture_action_bar.dart';
import '../widgets/tracked_log_capture_header.dart';
import '../widgets/tracked_log_capture_location_card.dart';
import '../widgets/tracked_log_capture_marker.dart';

class TrackedLogCaptureView extends StatelessWidget {
  const TrackedLogCaptureView({super.key, this.onCapture});

  final VoidCallback? onCapture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.trackedDashboardBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssetsPng.trackedHomeMapPreviewBg, fit: BoxFit.cover),
          const ColoredBox(color: AppColors.trackedMapPreviewOverlay),
          const Center(child: TrackedLogCaptureMarker()),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TrackedLogCaptureHeader(),
                Padding(
                  padding: AppInsets.only(top: 24, left: 24, right: 24),
                  child: TrackedLogCaptureLocationCard(
                    location: AppStrings.trackedLogDetailsDefaultLocation,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: TrackedLogCaptureActionBar(
              onCapture: onCapture ?? AppRouterGo.back,
            ),
          ),
        ],
      ),
    );
  }
}
