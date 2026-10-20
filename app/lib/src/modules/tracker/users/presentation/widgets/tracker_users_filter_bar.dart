import '../../../../../core/utils/app_exports.dart';

class TrackerUsersFilterBar extends StatelessWidget {
  const TrackerUsersFilterBar({
    super.key,
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final filter in filters)
              Padding(
                padding: AppInsets.only(right: 14),
                child: Semantics(
                  selected: selected == filter,
                  button: true,
                  child: InkWell(
                    borderRadius: 100.circular,
                    onTap: () => onSelected(filter),
                    child: Container(
                      padding: AppInsets.symmetric(horizontal: 15, vertical: 7),
                      decoration: BoxDecoration(
                        color: selected == filter
                            ? AppColors.trackerPurpleDeep
                            : AppColors.trackerSurfaceFill,
                        borderRadius: 100.circular,
                        border: Border.all(
                          color: AppColors.primaryWhite
                              .withValues(alpha: selected == filter ? 0 : .05),
                        ),
                      ),
                      child: Text(
                        filter,
                        style: context.bodySmallStyle?.copyWith(
                          fontSize: 12.sp,
                          color: AppColors.primaryWhite
                              .withValues(alpha: selected == filter ? 1 : .6),
                          fontWeight: FontWeight.w400,
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
