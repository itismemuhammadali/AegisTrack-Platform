import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../../domain/entities/tracker_share_entity.dart';

/// Four segments tracking progress through the wizard.
class TrackerShareStepBar extends StatelessWidget {
  const TrackerShareStepBar({
    super.key,
    required this.count,
    required this.current,
  });

  final int count;

  /// 0-based index of the step being shown.
  final int current;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          for (var i = 0; i < count; i++) ...[
            Expanded(
              child: Container(
                height: 4.h,
                decoration: BoxDecoration(
                  color: i <= current
                      ? AppColors.trackerPurpleDeep
                      : AppColors.trackerSurfaceFill,
                  borderRadius: 100.circular,
                ),
              ),
            ),
            if (i < count - 1) 6.pw,
          ],
        ],
      );
}

/// The card each step's content sits in.
class TrackerShareCard extends StatelessWidget {
  const TrackerShareCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 20.circular,
          border: Border.all(color: AppColors.trackerSurfaceFill),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrackerDetailText(title,
                size: 16, weight: FontWeight.w600, height: 24 / 16),
            16.ph,
            child,
          ],
        ),
      );
}

/// A radio row, used for both the content and expiry steps. The content step
/// adds an icon tile; the expiry step fills the whole row when selected.
class TrackerShareOptionRow extends StatelessWidget {
  const TrackerShareOptionRow({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
    this.fillWhenSelected = false,
  });

  final TrackerShareOptionEntity option;
  final bool selected;
  final VoidCallback onTap;
  final bool fillWhenSelected;

  @override
  Widget build(BuildContext context) => Semantics(
        selected: selected,
        inMutuallyExclusiveGroup: true,
        button: true,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: AppInsets.all(16),
            decoration: BoxDecoration(
              color: selected && fillWhenSelected
                  ? AppColors.trackerPurpleDeep
                  : AppColors.trackerSurfaceFill,
              borderRadius: 20.circular,
              border: Border.all(color: AppColors.trackerSurfaceFill),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (option.icon != null) ...[
                  Container(
                    width: 36.w,
                    height: 36.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.trackerSurfaceFill,
                      borderRadius: 20.circular,
                    ),
                    child: SvgPicture.asset(option.icon!,
                        width: 20.w, height: 20.w),
                  ),
                  16.pw,
                ] else ...[
                  _TrackerShareRadio(selected: selected),
                  16.pw,
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 4.h,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          TrackerDetailText(option.title,
                              weight: FontWeight.w500, height: 20 / 14),
                          if (option.badge.isNotEmpty)
                            Container(
                              padding: AppInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.trackerShareExpertFill,
                                borderRadius: 4.circular,
                                border: Border.all(
                                    color: AppColors.trackerShareExpertBorder),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                      AppAssetsSvg.trackerShareExpertLock,
                                      width: 10.w,
                                      height: 10.w),
                                  4.pw,
                                  TrackerDetailText(option.badge,
                                      size: 12,
                                      height: 16 / 12,
                                      weight: FontWeight.w600,
                                      color: AppColors.primaryWhite),
                                ],
                              ),
                            ),
                        ],
                      ),
                      2.ph,
                      TrackerDetailText(option.subtitle,
                          size: 12,
                          height: 16 / 12,
                          weight: FontWeight.w500,
                          color: AppColors.primaryWhite),
                    ],
                  ),
                ),
                if (option.icon != null) ...[
                  16.pw,
                  Padding(
                    padding: AppInsets.only(top: 2),
                    child: _TrackerShareRadio(selected: selected),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
}

class _TrackerShareRadio extends StatelessWidget {
  const _TrackerShareRadio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
        width: 16.w,
        height: 16.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color:
                selected ? AppColors.primaryWhite : AppColors.trackerBorderSoft,
          ),
        ),
        child: selected
            ? Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryWhite,
                ),
              )
            : null,
      );
}

/// Filled or outlined wizard button.
class TrackerShareButton extends StatelessWidget {
  const TrackerShareButton({
    super.key,
    required this.label,
    this.icon,
    this.trailingIcon,
    this.primary = false,
    this.borderColor,
    this.labelColor,
    this.onTap,
  });

  final String label;
  final String? icon;
  final String? trailingIcon;
  final bool primary;
  final Color? borderColor;
  final Color? labelColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: AppInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                primary ? AppColors.trackerPurpleDeep : AppColors.transparent,
            borderRadius: 20.circular,
            border: primary
                ? null
                : Border.all(
                    color: borderColor ?? AppColors.trackerSurfaceFill),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                SvgPicture.asset(icon!, width: 16.w, height: 16.w),
                8.pw,
              ],
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: TrackerDetailText(
                    label,
                    size: 16,
                    height: 24 / 16,
                    weight: primary ? FontWeight.w600 : FontWeight.w500,
                    color: labelColor ?? AppColors.primaryWhite,
                  ),
                ),
              ),
              if (trailingIcon != null) ...[
                8.pw,
                SvgPicture.asset(trailingIcon!, width: 16.w, height: 16.w),
              ],
            ],
          ),
        ),
      );
}
