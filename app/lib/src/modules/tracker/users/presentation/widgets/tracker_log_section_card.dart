import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_log_detail_entity.dart';
import 'tracker_detail_text.dart';

/// A titled section of the log record: an all-caps heading over label/value
/// rows. Shared by GPS · Location, Sync · Device and Event Details.
class TrackerLogSectionCard extends StatelessWidget {
  const TrackerLogSectionCard({
    super.key,
    required this.title,
    required this.fields,
    this.icon,
    this.trailing,
  });

  final String title;
  final List<TrackerLogFieldEntity> fields;
  final String? icon;

  /// Extra content below the rows, such as the notes box.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.trackerBorderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  SvgPicture.asset(icon!, width: 16.w, height: 16.w),
                  8.pw,
                ],
                Expanded(child: TrackerLogSectionTitle(title)),
              ],
            ),
            10.ph,
            for (final field in fields) ...[
              TrackerLogFieldRow(field: field),
              if (field != fields.last) 6.ph,
            ],
            if (trailing != null) trailing!,
          ],
        ),
      );
}

/// The all-caps, wide-tracked heading used by every log section.
class TrackerLogSectionTitle extends StatelessWidget {
  const TrackerLogSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: context.bodySmallStyle?.copyWith(
          fontSize: 12.sp,
          height: 16 / 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: AppColors.primaryWhite,
        ),
      );
}

class TrackerLogFieldRow extends StatelessWidget {
  const TrackerLogFieldRow({super.key, required this.field});

  final TrackerLogFieldEntity field;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrackerDetailText(field.label,
              size: 12, height: 16 / 12, color: AppColors.primaryWhite),
          8.pw,
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (field.leadingDot) ...[
                  Container(
                    width: 8.w,
                    height: 8.w,
                    margin: AppInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.trackerSuccessGreen,
                    ),
                  ),
                  6.pw,
                ],
                if (field.icon != null) ...[
                  Padding(
                    padding: AppInsets.only(top: 2),
                    child: SvgPicture.asset(field.icon!,
                        width: 12.w, height: 12.w),
                  ),
                  6.pw,
                ],
                Flexible(
                  child: Text(
                    field.value,
                    textAlign: TextAlign.right,
                    style: context.bodySmallStyle?.copyWith(
                      fontSize: 12.sp,
                      height: 16 / 12,
                      fontFamily: field.monospace ? 'monospace' : null,
                      color: field.valueColor ?? AppColors.viewerSignInText,
                      fontWeight: field.valueColor == null
                          ? FontWeight.w400
                          : FontWeight.w500,
                    ),
                  ),
                ),
                if (field.locked) ...[
                  6.pw,
                  Padding(
                    padding: AppInsets.only(top: 2),
                    child: SvgPicture.asset(AppAssetsSvg.trackerLogRowLock,
                        width: 12.w, height: 12.w),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
}
