import '../../../../../core/utils/app_exports.dart';

enum TrackedSubscriptionPlan {
  free(
    name: AppStrings.trackedPlanFreeName,
    tagline: AppStrings.trackedPlanFreeTagline,
    price: AppStrings.trackedPlanFreePrice,
    period: AppStrings.trackedPlanFreePeriod,
    icon: AppAssetsSvg.trackedPlanFreeIcon,
    accent: AppColors.trackedPlanFreeAccent,
    includedFeatureCount: 3,
  ),
  basic(
    name: AppStrings.trackedPlanBasicName,
    tagline: AppStrings.trackedPlanBasicTagline,
    price: AppStrings.trackedPlanBasicPrice,
    period: AppStrings.trackedPlanPerMonth,
    icon: AppAssetsSvg.trackedPlanBasicIcon,
    accent: AppColors.trackedPlanBasicAccent,
    includedFeatureCount: 6,
  ),
  professional(
    name: AppStrings.trackedPlanProfessionalName,
    tagline: AppStrings.trackedPlanProfessionalTagline,
    price: AppStrings.trackedPlanProfessionalPrice,
    period: AppStrings.trackedPlanPerMonth,
    icon: AppAssetsSvg.trackedPlanProfessionalIcon,
    accent: AppColors.primaryWhite,
    includedFeatureCount: 8,
    isPopular: true,
  ),
  expert(
    name: AppStrings.trackedPlanExpertName,
    tagline: AppStrings.trackedPlanExpertTagline,
    price: AppStrings.trackedPlanExpertPrice,
    period: AppStrings.trackedPlanPerMonth,
    icon: AppAssetsSvg.trackedPlanExpertIcon,
    accent: AppColors.trackedPlanExpertAccent,
    includedFeatureCount: 9,
  );

  const TrackedSubscriptionPlan({
    required this.name,
    required this.tagline,
    required this.price,
    required this.period,
    required this.icon,
    required this.accent,
    required this.includedFeatureCount,
    this.isPopular = false,
  });

  final String name;
  final String tagline;
  final String price;
  final String period;
  final String icon;
  final Color accent;
  final int includedFeatureCount;
  final bool isPopular;

  /// Figma uses 10% white for the neutral (Professional) tile and 13% of
  /// the accent colour for the rest.
  Color get iconBackground => this == professional
      ? accent.withValues(alpha: 0.1)
      : accent.withValues(alpha: 0.13);

  static const List<String> features = [
    AppStrings.trackedPlanFeatureUnlimitedLogs,
    AppStrings.trackedPlanFeatureHistory,
    AppStrings.trackedPlanFeatureEncryptedSync,
    AppStrings.trackedPlanFeatureAntiSpoofing,
    AppStrings.trackedPlanFeatureAiSearch,
    AppStrings.trackedPlanFeatureGeofencing,
    AppStrings.trackedPlanFeatureCheckIns,
    AppStrings.trackedPlanFeatureLiveTracking,
    AppStrings.trackedPlanFeatureSecureSharing,
  ];
}
