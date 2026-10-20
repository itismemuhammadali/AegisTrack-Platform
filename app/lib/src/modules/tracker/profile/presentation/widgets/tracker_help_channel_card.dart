import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_profile_row_entity.dart';

/// One of the four ways to reach support, laid out two to a row.
class TrackerHelpChannelCard extends StatelessWidget {
  const TrackerHelpChannelCard({super.key, required this.channel, this.onTap});

  final TrackerHelpChannelEntity channel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: AppInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.trackerSurfaceFill,
            borderRadius: 16.circular,
            border: Border.all(color: AppColors.trackerSurfaceFill),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: channel.iconFill,
                  borderRadius: 20.circular,
                ),
                child:
                    SvgPicture.asset(channel.icon, width: 16.w, height: 16.w),
              ),
              10.ph,
              Text(
                channel.title,
                style: context.bodyMediumStyle?.copyWith(
                  fontSize: 14.sp,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.viewerSignInText,
                ),
              ),
              4.ph,
              Text(
                channel.subtitle,
                overflow: TextOverflow.ellipsis,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  height: 1.2,
                  color: AppColors.trackerMutedText,
                ),
              ),
            ],
          ),
        ),
      );
}

/// The channel cards in a two-column grid.
class TrackerHelpChannelGrid extends StatelessWidget {
  const TrackerHelpChannelGrid({
    super.key,
    required this.channels,
    this.onChannelTap,
  });

  final List<TrackerHelpChannelEntity> channels;
  final ValueChanged<TrackerHelpChannelEntity>? onChannelTap;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < channels.length; i += 2) ...[
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _card(channels[i])),
                  10.pw,
                  Expanded(
                    child: i + 1 < channels.length
                        ? _card(channels[i + 1])
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            if (i + 2 < channels.length) 10.ph,
          ],
        ],
      );

  Widget _card(TrackerHelpChannelEntity channel) => TrackerHelpChannelCard(
        channel: channel,
        onTap: onChannelTap == null ? null : () => onChannelTap!(channel),
      );
}
