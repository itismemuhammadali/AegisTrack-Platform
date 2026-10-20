import '../../../../../core/utils/app_exports.dart';
import 'tracker_live_status_pill.dart';

/// Live position preview: the map still, the pulsing position marker and the
/// LIVE / LIVE POSITION pills, laid out against the 407.6pt Figma frame.
class TrackerLiveMap extends StatelessWidget {
  const TrackerLiveMap({super.key, required this.isOnline});

  final bool isOnline;

  static const _designWidth = 407.606;
  static const _designHeight = 255.985;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / _designWidth;
          final markerColor =
              isOnline ? AppColors.trackerOnlineGreen : AppColors.trackerAmber;
          return Container(
            height: _designHeight * scale,
            decoration: BoxDecoration(
              color: AppColors.trackerMapFill,
              borderRadius: 16.circular,
              border: Border.all(color: AppColors.trackerBorderSoft),
            ),
            child: ClipRRect(
              borderRadius: 16.circular,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(AppAssetsPng.trackerMapBg,
                        fit: BoxFit.cover),
                  ),
                  if (isOnline)
                    Positioned(
                      left: 333.8 * scale,
                      top: 11.99 * scale,
                      child: const TrackerLiveStatusPill(
                        label: AppStrings.trackerLiveBadge,
                        color: AppColors.trackerOnlineGreen,
                        fill: AppColors.trackerSuccessSurface,
                        border: AppColors.trackerOnlinePillBorder,
                        horizontal: 10,
                        vertical: 4,
                        onMap: true,
                      ),
                    ),
                  Positioned(
                    left: 182.28 * scale,
                    top: 106.47 * scale,
                    child: Container(
                      width: 40.76 * scale,
                      height: 40.76 * scale,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: markerColor.withValues(alpha: .2),
                      ),
                      child: Container(
                        width: 20 * scale,
                        height: 20 * scale,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: markerColor,
                          border: Border.all(
                              color: AppColors.trackerMapMarkerBorder),
                          boxShadow: [
                            BoxShadow(
                              color: markerColor.withValues(alpha: .5),
                              blurRadius: 15 * scale,
                              offset: Offset(0, 10 * scale),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 211.44 * scale,
                    child: Align(
                      child: isOnline
                          ? const TrackerLiveStatusPill(
                              label: AppStrings.trackerLivePosition,
                              color: AppColors.trackerOnlineGreen,
                              fill: AppColors.trackerOnlinePillFill,
                              border: AppColors.trackerOnlinePillBorder,
                              showDot: false,
                              onMap: true,
                            )
                          : const TrackerLiveStatusPill(
                              label: AppStrings.trackerLastPosition,
                              color: AppColors.trackerAmber,
                              fill: AppColors.trackerWarningSurface,
                              border: AppColors.trackerWarningBorder,
                              showDot: false,
                              onMap: true,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
