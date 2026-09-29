import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';
import '../../../home/presentation/widgets/tracker_home_header.dart';
import '../../domain/entities/tracker_case_entity.dart';
import '../controller/tracker_cases_controller.dart';
import '../widgets/tracker_case_card.dart';
import '../widgets/tracker_case_sos_card.dart';

class TrackerCasesView extends ConsumerWidget {
  const TrackerCasesView({
    super.key,
    this.onCaseSelected,
    this.onSosDetails,
    this.onNotifications,
  });

  final ValueChanged<TrackerCaseEntity>? onCaseSelected;
  final VoidCallback? onSosDetails;
  final VoidCallback? onNotifications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerCasesControllerProvider);

    return ListView(
      key: const PageStorageKey('tracker-cases'),
      padding: AppInsets.only(left: 24, right: 24, top: 24) +
          EdgeInsets.only(bottom: 24.h + MediaQuery.paddingOf(context).bottom),
      children: [
        TrackerHomeHeader(
            name: AppStrings.trackedSettingsProfileName,
            onNotifications: onNotifications),
        24.ph,
        const TrackerSectionTitle(AppStrings.trackerCases),
        24.ph,
        for (final caseEntity in controller.cases) ...[
          TrackerCaseCard(
            caseEntity: caseEntity,
            onTap: onCaseSelected == null
                ? null
                : () => onCaseSelected!(caseEntity),
          ),
          10.ph,
        ],
        TrackerCaseSosCard(
          name: controller.sosName,
          initials: controller.sosInitials,
          location: controller.sosLocation,
          time: controller.sosTime,
          onTap: onSosDetails,
        ),
      ],
    );
  }
}
