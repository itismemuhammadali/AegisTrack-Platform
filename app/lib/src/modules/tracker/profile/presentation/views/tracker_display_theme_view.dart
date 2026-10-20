import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_scaffold.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../../domain/entities/tracker_profile_row_entity.dart';
import '../controller/tracker_profile_controller.dart';
import '../widgets/tracker_theme_widgets.dart';

/// Theme choice, reached from the profile's Dark Mode row.
class TrackerDisplayThemeView extends ConsumerWidget {
  const TrackerDisplayThemeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerProfileControllerProvider);

    return TrackerDetailScaffold(
      title: AppStrings.trackerThemeTitle,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerThemeBackTooltip,
      child: ListView(
        key: const PageStorageKey('tracker-display-theme'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          TrackerCurrentThemeCard(mode: controller.themeMode),
          24.ph,
          for (final mode in TrackerThemeMode.values) ...[
            TrackerThemeOptionCard(
              mode: mode,
              selected: controller.themeMode == mode,
              onTap: () => controller.setThemeMode(mode),
            ),
            if (mode != TrackerThemeMode.values.last) 12.ph,
          ],
          24.ph,
          Container(
            width: double.infinity,
            padding: AppInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.trackerSurfaceFill,
              borderRadius: 16.circular,
              border: Border.all(color: AppColors.trackerSurfaceFill),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TrackerDetailText(AppStrings.trackerThemeAboutTitle,
                    size: 18,
                    weight: FontWeight.w600,
                    height: 27 / 18,
                    color: AppColors.primaryWhite),
                12.ph,
                const TrackerDetailText(AppStrings.trackerThemeAboutBody,
                    height: 22.75 / 14, color: AppColors.primaryWhite),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
