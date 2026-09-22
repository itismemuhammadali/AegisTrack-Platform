import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../../domain/entities/tracker_profile_row_entity.dart';

/// The viewer's current plan, in the purple gradient card.
class TrackerPlanCard extends StatelessWidget {
  const TrackerPlanCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: AppInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              AppColors.trackerPlanCardTop,
              AppColors.trackerPlanCardBottom,
            ],
          ),
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackerPlanCardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(AppAssetsSvg.trackerPlanStar,
                    width: 20.w, height: 20.w),
                8.pw,
                const Expanded(
                  child: TrackerDetailText(AppStrings.trackerPlanExpert,
                      size: 18,
                      weight: FontWeight.w600,
                      height: 28 / 18,
                      color: AppColors.primaryWhite),
                ),
                8.pw,
                Container(
                  padding: AppInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.trackerPlanBadgeFill,
                    borderRadius: 100.circular,
                  ),
                  child: const TrackerDetailText(AppStrings.trackerPlanActive,
                      size: 12,
                      height: 16 / 12,
                      weight: FontWeight.w600,
                      color: AppColors.trackerPurpleLight),
                ),
              ],
            ),
            12.ph,
            const TrackerDetailText(AppStrings.trackerPlanRenews,
                size: 12, height: 16 / 12, color: AppColors.primaryWhite),
            12.ph,
            Row(
              children: [
                SvgPicture.asset(AppAssetsSvg.trackerPlanCheck,
                    width: 14.w, height: 14.w),
                8.pw,
                const Expanded(
                  child: TrackerDetailText(AppStrings.trackerPlanAllUnlocked,
                      size: 12, height: 16 / 12, color: AppColors.primaryWhite),
                ),
              ],
            ),
          ],
        ),
      );
}

/// Feature availability across the four tiers.
class TrackerPlanComparisonTable extends StatelessWidget {
  const TrackerPlanComparisonTable({
    super.key,
    required this.tiers,
    required this.features,
  });

  final List<String> tiers;
  final List<TrackerPlanFeatureEntity> features;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackerSurfaceFill),
        ),
        child: Column(
          children: [
            _TrackerPlanRow(
              label: AppStrings.trackerPlanColumnFeature,
              labelWeight: FontWeight.w400,
              cells: [
                for (final tier in tiers)
                  TrackerDetailText(tier,
                      size: 12,
                      height: 16 / 12,
                      weight: FontWeight.w500,
                      color: AppColors.primaryWhite),
              ],
            ),
            for (final feature in features)
              _TrackerPlanRow(
                label: feature.label,
                last: feature == features.last,
                cells: [
                  for (final included in feature.tiers)
                    included
                        ? SvgPicture.asset(AppAssetsSvg.trackerPlanCheck,
                            width: 14.w, height: 14.w)
                        : const TrackerDetailText(
                            AppStrings.trackerPlanUnavailable,
                            size: 12,
                            height: 16 / 12,
                            color: AppColors.primaryWhite),
                ],
              ),
          ],
        ),
      );
}

class _TrackerPlanRow extends StatelessWidget {
  const _TrackerPlanRow({
    required this.label,
    required this.cells,
    this.labelWeight = FontWeight.w400,
    this.last = false,
  });

  final String label;
  final List<Widget> cells;
  final FontWeight labelWeight;
  final bool last;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: last
            ? null
            : const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColors.trackerSurfaceFill)),
              ),
        child: Row(
          children: [
            Expanded(
              // The label takes the slack: the tier cells only ever hold a
              // tick or a dash, so they need far less room.
              flex: 5,
              child: TrackerDetailText(label,
                  size: 12,
                  height: 16 / 12,
                  weight: labelWeight,
                  color: AppColors.primaryWhite),
            ),
            for (final cell in cells) Expanded(child: Center(child: cell)),
          ],
        ),
      );
}
