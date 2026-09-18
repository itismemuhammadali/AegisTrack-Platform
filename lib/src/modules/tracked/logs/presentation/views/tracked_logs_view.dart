import '../../../../../core/utils/app_exports.dart';
import '../controller/tracked_logs_controller.dart';
import '../widgets/tracked_log_entry_card.dart';

class TrackedLogsView extends ConsumerWidget {
  const TrackedLogsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackedLogsControllerProvider);

    return Padding(
      padding: AppInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.logHistory,
            style: context.headlineSmallStyle?.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryWhite,
            ),
          ),
          24.ph,
          Expanded(
            child: ListView.separated(
              padding: AppInsets.only(bottom: 24),
              itemCount: controller.entries.length,
              separatorBuilder: (context, index) => 16.ph,
              itemBuilder: (context, index) => TrackedLogEntryCard(
                entry: controller.entries[index],
                onTap: () => AppRouterGo.push(
                  trackedLogDetailsView,
                  extra: controller.entries[index],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
