import '../../../../../core/utils/app_exports.dart';

/// Route preview: the map still, the recorded/missing path and the markers
/// the design pins to it. Everything is laid out against the 407.6pt-wide
/// Figma frame and scaled to the available width, so the composition holds.
class TrackerMapPlaybackMap extends StatelessWidget {
  const TrackerMapPlaybackMap({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.zoneEntryTime,
    required this.checkInTime,
    required this.missingWindow,
  });

  final String startTime;
  final String endTime;
  final String zoneEntryTime;
  final String checkInTime;
  final String missingWindow;

  static const _designWidth = 407.606;
  static const _designHeight = 255.985;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / _designWidth;
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
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Image.asset(AppAssetsPng.trackerMapPlaybackBg,
                        fit: BoxFit.cover),
                  ),
                  Positioned(
                    left: 2.8 * scale,
                    top: -29.97 * scale,
                    width: 405.323 * scale,
                    height: 285.706 * scale,
                    child: SvgPicture.asset(
                        AppAssetsSvg.trackerMapPlaybackRoute,
                        fit: BoxFit.fill),
                  ),
                  _MapMarker(
                    left: 34.79 * scale,
                    top: 174.03 * scale,
                    scale: scale,
                    label: '${AppStrings.trackerMapStart} $startTime',
                    labelColor: AppColors.trackerOnlineGreen,
                    dotColor: AppColors.trackerSuccessGreen,
                  ),
                  _MapMarker(
                    left: 364.15 * scale,
                    top: 10.02 * scale,
                    scale: scale,
                    label: '${AppStrings.trackerMapEnd} $endTime',
                    labelColor: AppColors.trackerFlaggedRed,
                    dotColor: AppColors.trackerDangerRed,
                    labelOffset: -63.4,
                  ),
                  _MapMarker(
                    left: 150.8 * scale,
                    top: 94.01 * scale,
                    scale: scale,
                    label: '${AppStrings.trackerMapZoneEntry} $zoneEntryTime',
                    labelColor: AppColors.trackerOnlineGreen,
                    labelOffset: 23.99,
                    dot: _ZoneMarkerDot(scale: scale),
                  ),
                  _MapMarker(
                    left: 244.8 * scale,
                    top: 62.01 * scale,
                    scale: scale,
                    label: '${AppStrings.trackerMapCheckIn} $checkInTime',
                    labelColor: AppColors.trackerFlaggedRed,
                    dotColor: AppColors.trackerDangerRed,
                    hasHalo: true,
                  ),
                  Positioned(
                    left: 192.8 * scale,
                    top: 66.02 * scale,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6 * scale, vertical: 2 * scale),
                      decoration: BoxDecoration(
                        color: AppColors.trackerWarningSurface,
                        borderRadius: BorderRadius.circular(4 * scale),
                        border:
                            Border.all(color: AppColors.trackerWarningBorder),
                      ),
                      child: _MapLabel(
                        '${AppStrings.trackerMapMissing} $missingWindow',
                        color: AppColors.trackerAmber,
                        scale: scale,
                      ),
                    ),
                  ),
                  // Playback head, sitting on the route at the current time.
                  Positioned(
                    left: 150.8 * scale,
                    top: 100.03 * scale,
                    child: Container(
                      width: 20 * scale,
                      height: 20 * scale,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.trackerPurpleDeep,
                        border:
                            Border.all(color: AppColors.trackerMapMarkerBorder),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.trackerPurpleDeep
                                .withValues(alpha: .5),
                            blurRadius: 15 * scale,
                            offset: Offset(0, 10 * scale),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14.79 * scale,
                    top: 167.75 * scale,
                    child: _MapLegend(scale: scale),
                  ),
                ],
              ),
            ),
          );
        },
      );
}

class _MapLabel extends StatelessWidget {
  const _MapLabel(this.text, {required this.color, required this.scale});

  final String text;
  final Color color;
  final double scale;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: context.bodySmallStyle?.copyWith(
          fontSize: 12 * scale,
          height: 16 / 12,
          fontFamily: 'monospace',
          color: color,
        ),
      );
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({
    required this.left,
    required this.top,
    required this.scale,
    required this.label,
    required this.labelColor,
    this.dotColor,
    this.dot,
    this.labelOffset = 20,
    this.hasHalo = false,
  });

  final double left;
  final double top;
  final double scale;
  final String label;
  final Color labelColor;
  final Color? dotColor;
  final Widget? dot;
  final double labelOffset;
  final bool hasHalo;

  @override
  Widget build(BuildContext context) => Positioned(
        left: left,
        top: top,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            dot ??
                Container(
                  width: 16 * scale,
                  height: 16 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                    border: Border.all(color: AppColors.trackerMapMarkerBorder),
                    boxShadow: hasHalo
                        ? [
                            BoxShadow(
                              color: AppColors.trackerDangerRed
                                  .withValues(alpha: .3),
                              blurRadius: 8 * scale,
                              spreadRadius: 3 * scale,
                            ),
                          ]
                        : null,
                  ),
                ),
            Positioned(
              left: labelOffset * scale,
              top: 0,
              child: _MapLabel(label, color: labelColor, scale: scale),
            ),
          ],
        ),
      );
}

class _ZoneMarkerDot extends StatelessWidget {
  const _ZoneMarkerDot({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) => Container(
        width: 20 * scale,
        height: 20 * scale,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.trackerZoneMarkerFill,
          border: Border.all(color: AppColors.trackerOnlineGreen),
        ),
        child: Container(
          width: 6 * scale,
          height: 6 * scale,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.trackerOnlineGreen,
          ),
        ),
      );
}

class _MapLegend extends StatelessWidget {
  const _MapLegend({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegendRow(
            label: AppStrings.trackerLegendRecorded,
            color: AppColors.trackerOnlineGreen,
            fill: AppColors.trackerSuccessGreen,
            scale: scale,
          ),
          SizedBox(height: 4 * scale),
          _LegendRow(
            label: AppStrings.trackerLegendMissing,
            color: AppColors.trackerAmber,
            borderColor: AppColors.trackerAmber,
            scale: scale,
          ),
          SizedBox(height: 4 * scale),
          _LegendRow(
            label: AppStrings.trackerLegendSos,
            color: AppColors.trackerFlaggedRed,
            fill: AppColors.trackerDangerRed,
            scale: scale,
          ),
          SizedBox(height: 4 * scale),
          _LegendRow(
            label: AppStrings.trackerLegendZone,
            color: AppColors.trackerOnlineGreen,
            borderColor: AppColors.trackerOnlineGreen,
            scale: scale,
          ),
        ],
      );
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.label,
    required this.color,
    required this.scale,
    this.fill,
    this.borderColor,
  });

  final String label;
  final Color color;
  final double scale;
  final Color? fill;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 8 * scale,
            height: 8 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: fill,
              border:
                  borderColor == null ? null : Border.all(color: borderColor!),
            ),
          ),
          SizedBox(width: 6 * scale),
          Text(
            label,
            style: context.bodySmallStyle?.copyWith(
              fontSize: 12 * scale,
              height: 16 / 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ],
      );
}
