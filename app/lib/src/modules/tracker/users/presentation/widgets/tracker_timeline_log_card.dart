import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_timeline_log_entity.dart';

class TrackerTimelineLogCard extends StatelessWidget {
  const TrackerTimelineLogCard({super.key, required this.log, this.onTap});

  final TrackerTimelineLogEntity log;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: AppInsets.all(16),
          decoration: BoxDecoration(
            color: log.kind.cardFill ?? AppColors.trackerSurfaceFill,
            borderRadius: 16.circular,
            border: Border.all(
                color: log.kind.cardBorder ?? AppColors.trackerBorderSoft),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: AppInsets.only(top: 2),
                child: _TrackerTimelineLogAvatar(kind: log.kind),
              ),
              12.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TrackerTimelineLogTitle(log: log),
                    4.ph,
                    _TrackerTimelineLogTime(log: log),
                    if (log.location.isNotEmpty) ...[
                      8.ph,
                      Row(
                        children: [
                          SvgPicture.asset(AppAssetsSvg.trackerTimelineLocation,
                              width: 12.w, height: 12.w),
                          6.pw,
                          Expanded(
                            child: Text(
                              log.location,
                              style: _labelStyle(context,
                                  color: AppColors.primaryWhite),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (log.status != null) ...[
                      6.ph,
                      SizedBox(
                        width: double.infinity,
                        child:
                            _TrackerTimelineTag(tag: log.status!, iconSize: 14),
                      ),
                    ],
                    8.ph,
                    _TrackerTimelineLogFooter(log: log),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

TextStyle? _labelStyle(BuildContext context, {required Color color}) =>
    context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      height: 16 / 12,
      fontWeight: FontWeight.w500,
      color: color,
    );

class _TrackerTimelineLogAvatar extends StatelessWidget {
  const _TrackerTimelineLogAvatar({required this.kind});

  final TrackerTimelineLogKind kind;

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      width: 32.w,
      height: 32.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: kind.surface),
      child: SvgPicture.asset(kind.icon, width: 16.w, height: 16.w),
    );
    if (!kind.hasGlow) return badge;
    // The SOS log carries a soft halo behind its badge in the design.
    return Container(
      width: 32.w,
      height: 32.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.trackerDangerRed.withValues(alpha: .3),
            blurRadius: 12.w,
            spreadRadius: 6.w,
          ),
        ],
      ),
      child: badge,
    );
  }
}

class _TrackerTimelineLogTitle extends StatelessWidget {
  const _TrackerTimelineLogTitle({required this.log});

  final TrackerTimelineLogEntity log;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Flexible(
            child: Text(
              log.name,
              overflow: TextOverflow.ellipsis,
              style: context.bodyMediumStyle?.copyWith(
                fontSize: 14.sp,
                height: 20 / 14,
                fontWeight: FontWeight.w500,
                color: AppColors.viewerSignInText,
              ),
            ),
          ),
          8.pw,
          Container(
            padding: AppInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: log.kind.surface,
              borderRadius: 4.circular,
            ),
            child: Text(
              log.kind.label,
              style: context.bodySmallStyle?.copyWith(
                fontSize: 12.sp,
                height: 16 / 12,
                fontWeight: FontWeight.w600,
                letterSpacing: .3,
                color: log.kind.accent,
              ),
            ),
          ),
          const Spacer(),
          8.pw,
          SvgPicture.asset(AppAssetsSvg.trackerTimelineChevron,
              width: 16.w, height: 16.w),
        ],
      );
}

class _TrackerTimelineLogTime extends StatelessWidget {
  const _TrackerTimelineLogTime({required this.log});

  final TrackerTimelineLogEntity log;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SvgPicture.asset(AppAssetsSvg.trackerTimelineClock,
              width: 12.w, height: 12.w),
          6.pw,
          Text(
            log.time,
            style: context.bodySmallStyle?.copyWith(
              fontSize: 12.sp,
              height: 16 / 12,
              fontFamily: 'monospace',
              color: AppColors.primaryWhite,
            ),
          ),
          if (log.timeTag != null) ...[
            10.pw,
            Flexible(child: _TrackerTimelineTag(tag: log.timeTag!)),
          ],
        ],
      );
}

class _TrackerTimelineLogFooter extends StatelessWidget {
  const _TrackerTimelineLogFooter({required this.log});

  final TrackerTimelineLogEntity log;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 12.w,
              runSpacing: 6.h,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (log.authenticity != null)
                  Container(
                    padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: log.authenticity!.background,
                      borderRadius: 100.circular,
                    ),
                    child: Text(
                      log.authenticity!.label,
                      style:
                          _labelStyle(context, color: log.authenticity!.color),
                    ),
                  ),
                for (final tag in log.tags) _TrackerTimelineTag(tag: tag),
              ],
            ),
          ),
          8.pw,
          SvgPicture.asset(AppAssetsSvg.trackerTimelineLock,
              width: 12.w, height: 12.w),
        ],
      );
}

class _TrackerTimelineTag extends StatelessWidget {
  const _TrackerTimelineTag({required this.tag, this.iconSize = 12});

  final TrackerTimelineTagEntity tag;
  final double iconSize;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tag.icon != null) ...[
            SvgPicture.asset(tag.icon!, width: iconSize.w, height: iconSize.w),
            4.pw,
          ],
          Flexible(
            child: Text(
              tag.label,
              overflow: TextOverflow.ellipsis,
              style: _labelStyle(context, color: tag.color),
            ),
          ),
        ],
      );
}
