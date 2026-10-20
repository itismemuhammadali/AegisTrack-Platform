import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../../domain/entities/tracker_profile_row_entity.dart';

/// The theme in use, over a mock-up of what it looks like.
class TrackerCurrentThemeCard extends StatelessWidget {
  const TrackerCurrentThemeCard({super.key, required this.mode});

  final TrackerThemeMode mode;

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
            Row(
              children: [
                Container(
                  padding: AppInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.trackerNeutralSurface,
                    borderRadius: 20.circular,
                  ),
                  child: SvgPicture.asset(mode.icon, width: 24.w, height: 24.w),
                ),
                12.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TrackerDetailText(AppStrings.trackerThemeCurrent,
                          size: 20,
                          weight: FontWeight.w600,
                          height: 30 / 20,
                          color: AppColors.primaryWhite),
                      TrackerDetailText(mode.activeLabel,
                          height: 20 / 14, color: AppColors.primaryWhite),
                    ],
                  ),
                ),
              ],
            ),
            16.ph,
            // A wireframe of a screen in the chosen theme: a title bar, an
            // avatar and two lines of copy.
            Container(
              padding: AppInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.trackerSurfaceFill,
                borderRadius: 20.circular,
                border: Border.all(color: AppColors.trackerSurfaceFill),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: AppColors.trackerNeutralSurface,
                          borderRadius: 4.circular,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.trackerEditAvatarTop,
                              AppColors.trackerEditAvatarBottom,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  12.ph,
                  _bar(widthFactor: 1),
                  8.ph,
                  _bar(widthFactor: .75),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _bar({required double widthFactor}) => FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: widthFactor,
        child: Container(
          height: 8.h,
          decoration: BoxDecoration(
            color: AppColors.trackerThemePreviewBar,
            borderRadius: 4.circular,
          ),
        ),
      );
}

/// One selectable theme.
class TrackerThemeOptionCard extends StatelessWidget {
  const TrackerThemeOptionCard({
    super.key,
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final TrackerThemeMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        selected: selected,
        inMutuallyExclusiveGroup: true,
        button: true,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: AppInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.trackerSurfaceFill,
              borderRadius: 16.circular,
              border: Border.all(
                color: selected
                    ? AppColors.trackerPurpleDeep
                    : AppColors.trackerSurfaceFill,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: AppInsets.all(12),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.trackerPurpleDeep
                        : AppColors.trackerSurfaceFill,
                    borderRadius: 20.circular,
                  ),
                  child: SvgPicture.asset(mode.icon, width: 24.w, height: 24.w),
                ),
                16.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TrackerDetailText(mode.title,
                          size: 16,
                          weight: FontWeight.w600,
                          height: 24 / 16,
                          color: AppColors.primaryWhite),
                      4.ph,
                      TrackerDetailText(mode.note,
                          weight: FontWeight.w500,
                          height: 20 / 14,
                          color: AppColors.primaryWhite),
                    ],
                  ),
                ),
                // Only the chosen option carries a radio; the others show
                // nothing, as in the design.
                if (selected) ...[
                  16.pw,
                  Container(
                    width: 24.w,
                    height: 24.w,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.trackerPurpleDeep,
                    ),
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryWhite,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
}
