import '../../../../../core/utils/app_exports.dart';

class TrackedHomeStatsGrid extends StatelessWidget {
  const TrackedHomeStatsGrid({
    super.key,
    this.onLastSynced,
    this.onFailed,
    this.onZone,
    this.onCheckIn,
  });

  final VoidCallback? onLastSynced;
  final VoidCallback? onFailed;
  final VoidCallback? onZone;
  final VoidCallback? onCheckIn;

  @override
  Widget build(BuildContext context) {
    final valueStyle = context.bodyMediumStyle?.copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      height: 20 / 14,
      color: AppColors.primaryWhite,
    );
    final countStyle = context.headlineSmallStyle?.copyWith(
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
      height: 32 / 24,
      color: AppColors.primaryWhite,
    );
    final captionStyle = context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
    );

    return Column(
      children: [
        _StatRow(
          left: _StatCard(
            icon: AppAssetsSvg.trackedHomeStatGps,
            label: AppStrings.gpsStatus,
            value: Text(
              AppStrings.gpsStatusActive,
              style: context.titleMediumStyle?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                height: 28 / 18,
                color: AppColors.primaryWhite,
              ),
            ),
          ),
          right: _StatCard(
            icon: AppAssetsSvg.trackedHomeStatSynced,
            label: AppStrings.lastSynced,
            value: Text(AppStrings.lastSyncedValue, style: valueStyle),
            onTap: onLastSynced,
          ),
        ),
        16.ph,
        _StatRow(
          left: _StatCard(
            icon: AppAssetsSvg.trackedHomeStatPending,
            label: AppStrings.pending,
            value: Text('3', style: countStyle),
          ),
          right: _StatCard(
            icon: AppAssetsSvg.trackedHomeStatFailed,
            label: AppStrings.failed,
            value: Text('1', style: countStyle),
            onTap: onFailed,
          ),
        ),
        16.ph,
        _StatRow(
          left: _StatCard(
            icon: AppAssetsSvg.trackedHomeStatZone,
            label: AppStrings.zone,
            value: Text(AppStrings.zoneName, style: valueStyle),
            footer: Text(
              AppStrings.zoneAllowedArea,
              style: captionStyle?.copyWith(
                color: AppColors.trackedZoneAllowedGreen,
              ),
            ),
            onTap: onZone,
          ),
          right: _StatCard(
            leading: Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.trackedCheckInAmber.withValues(alpha: 0.61),
              ),
            ),
            label: AppStrings.checkIn,
            value: Text(
              AppStrings.checkInDueNow,
              style: valueStyle?.copyWith(
                color: AppColors.trackedCheckInAmber,
              ),
            ),
            footer: Text(
              AppStrings.checkInTime,
              style: captionStyle?.copyWith(
                color: AppColors.signInDarkSubtitle,
              ),
            ),
            accent: AppColors.trackedCheckInAmber,
            onTap: onCheckIn,
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: left),
          16.pw,
          Expanded(child: right),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.icon,
    this.leading,
    this.footer,
    this.accent,
    this.onTap,
  });

  final String label;
  final Widget value;
  final String? icon;
  final Widget? leading;
  final Widget? footer;

  /// Tints the card background/border (used by the Check-in card).
  final Color? accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: (accent ?? AppColors.primaryWhite).withValues(
            alpha: accent == null ? 0.05 : 0.1,
          ),
          borderRadius: 16.circular,
          border: Border.all(
            color: (accent ?? AppColors.primaryWhite).withValues(
              alpha: accent == null ? 0.1 : 0.3,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                leading ?? SvgPicture.asset(icon!, width: 16.w, height: 16.w),
                8.pw,
                Text(
                  label,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    height: 16 / 12,
                    color: AppColors.primaryWhite.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
            8.ph,
            value,
            if (footer != null) ...[2.ph, footer!],
          ],
        ),
      ),
    );
  }
}
