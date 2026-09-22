import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';
import '../../../home/presentation/widgets/tracker_home_header.dart';
import '../../../home/presentation/widgets/tracker_user_card.dart';
import '../controller/tracker_users_controller.dart';
import '../widgets/tracker_users_filter_bar.dart';
import '../widgets/tracker_users_search_field.dart';

class TrackerUsersView extends ConsumerWidget {
  const TrackerUsersView(
      {super.key, this.onUserSelected, this.onNotifications});

  final ValueChanged<TrackerUserEntity>? onUserSelected;
  final VoidCallback? onNotifications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerUsersControllerProvider);
    final users = controller.visibleUsers;

    return ListView(
      key: const PageStorageKey('tracker-users'),
      padding: AppInsets.only(left: 24, right: 24, top: 24) +
          EdgeInsets.only(bottom: 24.h + MediaQuery.paddingOf(context).bottom),
      children: [
        TrackerHomeHeader(
            name: AppStrings.trackedSettingsProfileName,
            onNotifications: onNotifications),
        24.ph,
        const TrackerSectionTitle(AppStrings.trackerAssignedUsers,
            mutedSubtitle: true),
        24.ph,
        TrackerUsersSearchField(onChanged: controller.setQuery),
        10.ph,
        TrackerUsersFilterBar(
          filters: TrackerUsersController.filters,
          selected: controller.filter,
          onSelected: controller.setFilter,
        ),
        24.ph,
        if (users.isEmpty)
          Padding(
            padding: AppInsets.all(24),
            child: Text(
              AppStrings.trackerUsersEmpty,
              textAlign: TextAlign.center,
              style: context.bodyMediumStyle
                  ?.copyWith(color: AppColors.trackerMutedText),
            ),
          ),
        for (final user in users)
          Padding(
            padding: AppInsets.only(bottom: 10),
            child: GestureDetector(
              onTap:
                  onUserSelected == null ? null : () => onUserSelected!(user),
              child: TrackerUserCard(user: user, compact: true),
            ),
          ),
      ],
    );
  }
}
