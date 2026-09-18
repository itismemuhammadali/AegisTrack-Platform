import '../../../../../core/utils/app_exports.dart';

class TrackedZoneSummaryCard extends StatelessWidget {
  const TrackedZoneSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    const green = AppColors.trackedZoneAllowedGreen;

    return Container(
      width: double.infinity,
      padding: AppInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 16.circular,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.13),
                  borderRadius: 16.circular,
                ),
                child: SvgPicture.asset(
                  AppAssetsSvg.trackedZoneShield,
                  width: 24.w,
                  height: 24.w,
                ),
              ),
              16.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.zoneStatusName,
                      style: context.titleMediumStyle?.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        height: 22.5 / 18,
                        color: AppColors.primaryWhite,
                      ),
                    ),
                    6.ph,
                    Container(
                      padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: green.withValues(alpha: 0.13),
                        borderRadius: 100.circular,
                      ),
                      child: Text(
                        AppStrings.zoneAllowedArea,
                        style: context.bodySmallStyle?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          height: 16 / 12,
                          color: green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          10.ph,
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(
                  child: _ZoneStat(
                    icon: AppAssetsSvg.trackedZoneStatus,
                    label: AppStrings.zoneStatusLabel,
                    value: AppStrings.zoneStatusInside,
                  ),
                ),
                10.pw,
                const Expanded(
                  child: _ZoneStat(
                    icon: AppAssetsSvg.trackedZoneClock,
                    label: AppStrings.zoneStatusLastUpdate,
                    value: AppStrings.zoneStatusJustNow,
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

class _ZoneStat extends StatelessWidget {
  const _ZoneStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryblack.withValues(alpha: 0.2),
        borderRadius: 18.circular,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, width: 12.w, height: 12.w),
              6.pw,
              Text(
                label,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  height: 16 / 12,
                  color: AppColors.hintGray,
                ),
              ),
            ],
          ),
          4.ph,
          Text(
            value,
            style: context.bodyMediumStyle?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
              color: AppColors.primaryWhite,
            ),
          ),
        ],
      ),
    );
  }
}
