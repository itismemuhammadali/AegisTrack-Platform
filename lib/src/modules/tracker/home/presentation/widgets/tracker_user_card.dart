import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_user_entity.dart';

class TrackerUserCard extends StatelessWidget {
  const TrackerUserCard(
      {super.key, required this.user, this.onAction, this.compact = false});

  final TrackerUserEntity user;
  final bool compact;
  final void Function(String action)? onAction;

  static const _actions = [
    (AppAssetsSvg.trackerActionVideo, AppStrings.trackerActionVideo),
    (AppAssetsSvg.trackerActionTimeline, AppStrings.trackerActionTimeline),
    (AppAssetsSvg.trackerActionMap, AppStrings.trackerActionMap),
    (AppAssetsSvg.trackerActionLive, AppStrings.trackerActionLive),
    (AppAssetsSvg.trackerActionAlerts, AppStrings.trackerActionAlerts),
    (AppAssetsSvg.trackerActionAi, AppStrings.trackerActionAi),
  ];

  @override
  Widget build(BuildContext context) {
    final isVerified = user.authenticity == TrackerAuthenticity.verified;
    final authColor =
        isVerified ? AppColors.trackerOnlineGreen : AppColors.trackerAmber;

    return Container(
      padding: AppInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 16.circular,
        border: Border.all(
          color: AppColors.primaryWhite.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryblack.withValues(alpha: 0.25),
            blurRadius: 50,
            spreadRadius: -12,
            offset: Offset(0, 25.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  AppAssetsPng.trackerUserAvatar,
                  width: 40.w,
                  height: 40.w,
                  fit: BoxFit.cover,
                ),
              ),
              10.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: context.bodyMediumStyle?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        height: 20 / 14,
                        color: AppColors.viewerSignInText,
                      ),
                    ),
                    Text(
                      user.lastSeen,
                      style: context.bodySmallStyle?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryWhite.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (user.isOnline || compact) ...[
                _Badge(
                  background: compact && !user.isOnline && !user.isSos
                      ? Colors.transparent
                      : null,
                  label: user.isSos
                      ? 'SOS'
                      : user.isOnline
                          ? AppStrings.trackerOnline
                          : 'Offline',
                  color: user.isSos
                      ? Colors.red
                      : user.isOnline
                          ? AppColors.trackerOnlineGreen
                          : Colors.white.withValues(alpha: .6),
                ),
                8.pw,
              ],
              _Badge(
                label: isVerified
                    ? AppStrings.trackerVerified
                    : user.authenticity == TrackerAuthenticity.questionable
                        ? 'Questionable'
                        : AppStrings.trackerAcceptable,
                color: authColor,
              ),
            ],
          ),
          (compact ? 16 : 10).ph,
          Row(
            children: [
              SvgPicture.asset(
                AppAssetsSvg.trackerUserLocation,
                width: 16.w,
                height: 16.w,
              ),
              8.pw,
              Expanded(
                child: Text(
                  user.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodyMediumStyle?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                    color: AppColors.primaryWhite.withValues(alpha: 0.6),
                  ),
                ),
              ),
              if (compact)
                SvgPicture.asset(AppAssetsSvg.trackerAlertChevron,
                    width: 16.w, height: 16.w),
            ],
          ),
          if (!compact) ...[
            10.ph,
            // Six links across a phone width — scale down rather than overflow.
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final (icon, label) in _actions)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onAction?.call(label),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(icon, width: 14.w, height: 14.w),
                          4.pw,
                          Text(
                            label,
                            style: context.bodySmallStyle?.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              height: 16 / 12,
                              color:
                                  AppColors.primaryWhite.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color, this.background});

  final String label;
  final Color color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: background ?? color.withValues(alpha: 0.1),
        borderRadius: 100.circular,
      ),
      child: Text(
        label,
        style: context.bodySmallStyle?.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
