import '../../../../../core/utils/app_exports.dart';

class TrackedLiveMapView extends StatelessWidget {
  const TrackedLiveMapView({
    super.key,
    this.onRefresh,
    this.onLogNow,
    this.onCapture,
  });

  final VoidCallback? onRefresh;
  final VoidCallback? onLogNow;
  final VoidCallback? onCapture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.trackedLogCaptureHeaderBackdrop,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 0.5, 1],
            colors: [
              AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
              AppColors.onboardingScrimNavy.withValues(alpha: 0.9),
              AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: AppInsets.only(left: 24, right: 24, top: 24),
                child: Row(
                  children: [
                    _GlassIconButton(
                      icon: AppAssetsSvg.trackedLiveMapBack,
                      onTap: AppRouterGo.back,
                    ),
                    Expanded(
                      child: Text(
                        AppStrings.liveMap,
                        textAlign: TextAlign.center,
                        style: context.titleLargeStyle?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          height: 28 / 20,
                          color: AppColors.primaryWhite,
                        ),
                      ),
                    ),
                    _GlassIconButton(
                      icon: AppAssetsSvg.trackedLiveMapRefresh,
                      onTap: onRefresh,
                    ),
                  ],
                ),
              ),
              24.ph,
              const Expanded(child: _MapArea()),
              24.ph,
              Padding(
                padding: AppInsets.only(left: 24, right: 24, bottom: 0),
                child: Column(
                  children: [
                    const _CurrentLocationCard(),
                    16.ph,
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: AppAssetsSvg.trackedHomeQuickActionLogNow,
                            label: AppStrings.logNow,
                            isPrimary: true,
                            onTap: onLogNow,
                          ),
                        ),
                        16.pw,
                        Expanded(
                          child: _ActionButton(
                            icon: AppAssetsSvg.trackedHomeQuickActionCapture,
                            label: AppStrings.capture,
                            onTap: onCapture,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapArea extends StatelessWidget {
  const _MapArea();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AppAssetsPng.trackedLiveMapBg, fit: BoxFit.cover),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 170.w,
              height: 170.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryWhite.withValues(alpha: 0.2),
                border: Border.all(
                  color: AppColors.primaryWhite.withValues(alpha: 0.4),
                ),
              ),
              // Figma's pin artwork sits ~4px below the circle's centre.
              child: Transform.translate(
                offset: Offset(0, 4.4.w),
                child: SvgPicture.asset(
                  AppAssetsSvg.trackedLiveMapPin,
                  width: 70.w,
                  height: 70.w,
                ),
              ),
            ),
            24.ph,
            Text(
              AppStrings.liveMapUpcoming.toUpperCase(),
              style: context.bodySmallStyle?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                height: 16 / 12,
                letterSpacing: 0.3,
                color: AppColors.primaryWhite,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CurrentLocationCard extends StatelessWidget {
  const _CurrentLocationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.1),
        borderRadius: 24.circular,
        border: Border.all(
          color: AppColors.primaryWhite.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryblack.withValues(alpha: 0.25),
            blurRadius: 50,
            offset: Offset(0, 25.h),
          ),
        ],
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
                  color: AppColors.primaryWhite.withValues(alpha: 0.2),
                  borderRadius: 18.circular,
                ),
                child: SvgPicture.asset(
                  AppAssetsSvg.trackedLiveMapNavigation,
                  width: 24.w,
                  height: 24.w,
                ),
              ),
              12.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.liveMapCurrentLocation,
                      style: context.titleMediumStyle?.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        height: 27 / 18,
                        color: AppColors.primaryWhite,
                      ),
                    ),
                    4.ph,
                    Text(
                      AppStrings.liveMapCoordinates,
                      style: context.bodyMediumStyle?.copyWith(
                        fontSize: 14.sp,
                        height: 20 / 14,
                        color: AppColors.signInDarkSubtitle,
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
                  child: _MetricTile(
                    icon: AppAssetsSvg.trackedLiveMapAccuracy,
                    label: AppStrings.liveMapAccuracy,
                    value: AppStrings.liveMapAccuracyValue,
                  ),
                ),
                16.pw,
                const Expanded(
                  child: _MetricTile(
                    icon: AppAssetsSvg.trackedLiveMapUpdated,
                    label: AppStrings.liveMapUpdated,
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

class _MetricTile extends StatelessWidget {
  const _MetricTile({
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
      padding: AppInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 18.circular,
      ),
      child: Row(
        children: [
          SvgPicture.asset(icon, width: 16.w, height: 16.w),
          8.pw,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  height: 16 / 12,
                  color: AppColors.hintGray,
                ),
              ),
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
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.icon, this.onTap});

  final String icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryWhite.withValues(alpha: 0.1),
          borderRadius: 18.circular,
          border: Border.all(
            color: AppColors.primaryWhite.withValues(alpha: 0.2),
          ),
        ),
        child: SvgPicture.asset(icon, width: 20.w, height: 20.w),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    this.isPrimary = false,
    this.onTap,
  });

  final String icon;
  final String label;
  final bool isPrimary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color:
              isPrimary ? null : AppColors.primaryWhite.withValues(alpha: 0.1),
          gradient: isPrimary
              ? const LinearGradient(
                  colors: AppColors.trackedQuickActionGradientColors,
                )
              : null,
          borderRadius: 16.circular,
          border: isPrimary
              ? null
              : Border.all(
                  color: AppColors.primaryWhite.withValues(alpha: 0.2),
                ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppColors.trackedQuickActionShadow,
                    blurRadius: 3,
                    offset: Offset(0, 4.h),
                  ),
                  BoxShadow(
                    color: AppColors.trackedQuickActionShadow,
                    blurRadius: 7.5,
                    offset: Offset(0, 10.h),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, width: 20.w, height: 20.w),
            12.pw,
            Text(
              label,
              style: context.bodyLargeStyle?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                height: 24 / 16,
                color: AppColors.primaryWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
