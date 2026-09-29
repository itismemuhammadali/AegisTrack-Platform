import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../../domain/entities/tracker_report_entity.dart';

/// PDF / CSV segmented control.
class TrackerReportFormatToggle extends StatelessWidget {
  const TrackerReportFormatToggle({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final TrackerReportFormat selected;
  final ValueChanged<TrackerReportFormat> onSelected;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final format in TrackerReportFormat.values) ...[
              Expanded(
                child: Semantics(
                  selected: format == selected,
                  button: true,
                  child: GestureDetector(
                    onTap: () => onSelected(format),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      alignment: Alignment.center,
                      padding: AppInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: format == selected
                            ? AppColors.trackerPurpleDeep
                            : AppColors.trackerSurfaceFill,
                        borderRadius: 20.circular,
                        border: Border.all(
                          color: format == selected
                              ? AppColors.trackerPurpleDeep
                              : AppColors.trackerSurfaceFill,
                        ),
                      ),
                      child: TrackerDetailText(
                        format.label,
                        weight: FontWeight.w500,
                        height: 20 / 14,
                        color: format == selected
                            ? AppColors.viewerSignInText
                            : AppColors.primaryWhite,
                      ),
                    ),
                  ),
                ),
              ),
              if (format != TrackerReportFormat.values.last) 8.pw,
            ],
          ],
        ),
      );
}

/// A labelled export option. The design shows the collapsed control only, so
/// tapping reports the field rather than opening a picker.
class TrackerReportDropdown extends StatelessWidget {
  const TrackerReportDropdown({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    this.onTap,
  });

  final String label;
  final String icon;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, width: 14.w, height: 14.w),
              6.pw,
              Expanded(child: TrackerReportFieldLabel(label)),
            ],
          ),
          6.ph,
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: AppInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.trackerSurfaceFill,
                borderRadius: 20.circular,
                border: Border.all(color: AppColors.trackerSurfaceFill),
              ),
              child: Row(
                children: [
                  Expanded(child: TrackerDetailText(value)),
                  8.pw,
                  SvgPicture.asset(AppAssetsSvg.trackerReportChevron,
                      width: 10.w, height: 6.w),
                ],
              ),
            ),
          ),
        ],
      );
}

/// All-caps field heading shared by the dropdowns and the includes list.
class TrackerReportFieldLabel extends StatelessWidget {
  const TrackerReportFieldLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: context.bodySmallStyle?.copyWith(
          fontSize: 12.sp,
          height: 16 / 12,
          fontWeight: FontWeight.w500,
          letterSpacing: .6,
          color: AppColors.primaryWhite,
        ),
      );
}

/// The AI narrative switch closing the includes list.
class TrackerReportSwitch extends StatelessWidget {
  const TrackerReportSwitch({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final bool value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.only(top: 12),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.trackerSurfaceFill)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TrackerDetailText(label,
                  size: 12, height: 16 / 12, color: AppColors.primaryWhite),
            ),
            8.pw,
            Semantics(
              toggled: value,
              child: GestureDetector(
                onTap: onTap,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 40.w,
                  height: 22.w,
                  padding: AppInsets.all(3),
                  alignment:
                      value ? Alignment.centerRight : Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: value
                        ? AppColors.trackerPurpleDeep
                        : AppColors.trackerSurfaceFill,
                    borderRadius: 100.circular,
                    border: Border.all(color: AppColors.trackerSurfaceFill),
                  ),
                  child: Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryWhite,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.authToggleShadow,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

/// Outline / filled action pair used by Preview and Export.
class TrackerReportActionButton extends StatelessWidget {
  const TrackerReportActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.primary = false,
    this.onTap,
  });

  final String label;
  final String icon;
  final bool primary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          alignment: Alignment.center,
          padding: AppInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: primary
                ? AppColors.trackerPurpleDeep
                : AppColors.trackerSurfaceFill,
            borderRadius: 20.circular,
            border: primary
                ? null
                : Border.all(color: AppColors.trackerSurfaceFill),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(icon, width: 16.w, height: 16.w),
              8.pw,
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: TrackerDetailText(label,
                      weight: FontWeight.w500, height: 20 / 14),
                ),
              ),
            ],
          ),
        ),
      );
}
