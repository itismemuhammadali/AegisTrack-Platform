import '../../../../../core/utils/app_exports.dart';

/// Segmented control switching the case detail between Timeline, Evidence and
/// Reports.
class TrackerCaseTabBar extends StatelessWidget {
  const TrackerCaseTabBar({
    super.key,
    required this.tabs,
    required this.selected,
    required this.onSelected,
  });

  final List<String> tabs;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Container(
        padding: AppInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.trackerSurfaceFill,
          borderRadius: 20.circular,
          border: Border.all(color: AppColors.trackerSurfaceFill),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final tab in tabs) ...[
                Expanded(
                  child: Semantics(
                    selected: selected == tab,
                    button: true,
                    child: GestureDetector(
                      onTap: () => onSelected(tab),
                      // Opaque, so the whole segment answers the tap and not
                      // just the label glyphs.
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        alignment: Alignment.center,
                        padding: AppInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selected == tab
                              ? AppColors.trackerPurpleDeep
                              : AppColors.transparent,
                          borderRadius: 16.circular,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            tab,
                            style: context.bodySmallStyle?.copyWith(
                              fontSize: 12.sp,
                              height: 1.2,
                              color: selected == tab
                                  ? AppColors.viewerSignInText
                                  : AppColors.trackerMutedText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (tab != tabs.last) 4.pw,
              ],
            ],
          ),
        ),
      );
}
