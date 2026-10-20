import '../../../../../core/utils/app_exports.dart';
import '../../../users/presentation/widgets/tracker_detail_scaffold.dart';
import '../../../users/presentation/widgets/tracker_detail_text.dart';
import '../controller/tracker_profile_controller.dart';
import '../widgets/tracker_edit_profile_widgets.dart';

/// Editable viewer profile, reached from the profile's Edit Profile row.
class TrackerEditProfileView extends ConsumerWidget {
  const TrackerEditProfileView({super.key, this.onSaved, this.onChangePhoto});

  final VoidCallback? onSaved;
  final VoidCallback? onChangePhoto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trackerProfileControllerProvider);

    return TrackerDetailScaffold(
      title: AppStrings.trackerEditProfileTitle,
      titleColor: AppColors.primaryWhite,
      backTooltip: AppStrings.trackerEditProfileBackTooltip,
      // The title is centred between the back arrow and a save action, so the
      // default left-aligned header row does not apply here.
      header: _TrackerEditProfileHeader(
        onSave: () => controller.saveProfile(
          onSaved: onSaved ?? () => Navigator.of(context).pop(),
        ),
      ),
      child: ListView(
        key: const PageStorageKey('tracker-edit-profile'),
        padding: AppInsets.only(left: 24, right: 24, bottom: 24),
        children: [
          // Rebuilds the avatar initials as the name is typed.
          ListenableBuilder(
            listenable: controller.nameController,
            builder: (context, _) => TrackerEditProfileAvatar(
              initials: controller.initials,
              onChangePhoto: onChangePhoto,
            ),
          ),
          24.ph,
          TrackerEditProfileField(
            label: AppStrings.trackerEditProfileFullName,
            controller: controller.nameController,
          ),
          10.ph,
          TrackerEditProfileField(
            label: AppStrings.trackerEditProfileUsername,
            controller: controller.usernameController,
          ),
          10.ph,
          TrackerEditProfileField(
            label: AppStrings.trackerEditProfileBio,
            controller: controller.bioController,
            lines: 4,
          ),
          10.ph,
          TrackerEditProfileField(
            label: AppStrings.trackerEditProfileLocation,
            controller: controller.locationController,
            filled: true,
          ),
          24.ph,
          GestureDetector(
            onTap: () => controller.saveProfile(
              onSaved: onSaved ?? () => Navigator.of(context).pop(),
            ),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: AppInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.trackerPurpleDeep,
                borderRadius: 16.circular,
              ),
              child: const TrackerDetailText(
                  AppStrings.trackerEditProfileSaveChanges,
                  size: 16,
                  weight: FontWeight.w500,
                  height: 24 / 16,
                  color: AppColors.primaryWhite),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackerEditProfileHeader extends StatelessWidget {
  const _TrackerEditProfileHeader({this.onSave});

  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: IconButton(
              tooltip: AppStrings.trackerEditProfileBackTooltip,
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.trackerSurfaceFill,
                shape: RoundedRectangleBorder(
                  borderRadius: 18.circular,
                  side: const BorderSide(color: AppColors.trackerSurfaceFill),
                ),
              ),
              icon: SvgPicture.asset(AppAssetsSvg.trackerUserDetailBack,
                  width: 20.w, height: 20.w),
            ),
          ),
          const Expanded(
            child: Center(
              child: TrackerDetailText(AppStrings.trackerEditProfileTitle,
                  size: 24,
                  weight: FontWeight.w600,
                  height: 32 / 24,
                  color: AppColors.primaryWhite),
            ),
          ),
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: IconButton(
              tooltip: AppStrings.trackerEditProfileSaveTooltip,
              onPressed: onSave,
              padding: EdgeInsets.zero,
              icon: SvgPicture.asset(AppAssetsSvg.trackerEditProfileSave,
                  width: 24.w, height: 24.w),
            ),
          ),
        ],
      );
}
