import '../../../../../core/utils/app_exports.dart';
import '../controller/tracked_settings_controller.dart';
import '../widgets/tracked_export_center_format_card.dart';
import '../widgets/tracked_export_center_header.dart';
import '../widgets/tracked_export_center_summary_card.dart';

class TrackedExportCenterView extends ConsumerWidget {
  const TrackedExportCenterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedSettingsControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.trackedDashboardBackground,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 0.5, 1],
            colors: [
              AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
              AppColors.onboardingScrimNavy.withValues(alpha: 0.9),
              AppColors.onboardingScrimNavy.withValues(alpha: 0.4),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const TrackedExportCenterHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppInsets.only(left: 24, right: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TrackedExportCenterSummaryCard(
                        count: controller.exportReadyLogsCount,
                      ),
                      24.ph,
                      Text(
                        AppStrings.trackedExportCenterChooseFormat,
                        style: context.bodyMediumStyle?.copyWith(
                          color: AppColors.primaryWhite,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      12.ph,
                      for (final format in controller.exportFormats) ...[
                        TrackedExportCenterFormatCard(
                          format: format,
                          onTap: () => controller.exportFormat(format),
                        ),
                        if (format != controller.exportFormats.last) 10.ph,
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
