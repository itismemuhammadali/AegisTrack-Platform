import '../../../../../core/utils/app_exports.dart';

class TrackerTimelineFilterBar extends StatelessWidget {
  const TrackerTimelineFilterBar({
    super.key,
    required this.filters,
    required this.selected,
    required this.onSelected,
    this.radius = 100,
  });

  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelected;

  /// Chip corner radius: pill-shaped on the timeline, rounded on check-ins.
  final double radius;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final filter in filters)
              Padding(
                padding: AppInsets.only(right: 8),
                child: Semantics(
                  selected: selected == filter,
                  button: true,
                  // A GestureDetector rather than an InkWell: a focusable
                  // chip can pull the row to the focused chip on entry, so the
                  // bar must only move when the user drags it.
                  child: GestureDetector(
                    onTap: () => onSelected(filter),
                    child: Container(
                      padding: AppInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected == filter
                            ? AppColors.trackerPurpleDeep
                            : AppColors.trackerSurfaceFill,
                        borderRadius: radius.circular,
                        border: selected == filter
                            ? null
                            : Border.all(color: AppColors.trackerBorderSoft),
                      ),
                      child: Text(
                        filter,
                        style: context.bodySmallStyle?.copyWith(
                          fontSize: 12.sp,
                          height: 16 / 12,
                          color: AppColors.primaryWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}
