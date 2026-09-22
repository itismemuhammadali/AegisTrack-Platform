import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_profile_row_entity.dart';

/// Figma sample profile; replace with the viewer account API.
class TrackerProfileController extends ChangeNotifier with Buffers {
  final String name = AppStrings.trackerProfileName;
  final String email = AppStrings.trackerProfileEmail;

  final List<(String, String)> stats = const [
    ('12', AppStrings.trackerProfileAssigned),
    ('248', AppStrings.trackerProfileLogs),
    ('3', AppStrings.trackerProfileCases),
  ];

  final List<TrackerProfileSectionEntity> sections = const [
    TrackerProfileSectionEntity(
      title: AppStrings.trackerSectionAccount,
      rows: [
        TrackerProfileRowEntity(
          label: AppStrings.trackerEditProfile,
          icon: AppAssetsSvg.trackerProfilePerson,
        ),
        TrackerProfileRowEntity(
          label: AppStrings.trackerEmailSettings,
          icon: AppAssetsSvg.trackerProfileEmail,
          value: 'alex.viewer@...',
        ),
        TrackerProfileRowEntity(
          label: AppStrings.trackerPhoneNumber,
          icon: AppAssetsSvg.trackerProfilePhone,
          value: '+1 •••• 4821',
        ),
      ],
    ),
    TrackerProfileSectionEntity(
      title: AppStrings.trackerSectionViewerAccess,
      rows: [
        TrackerProfileRowEntity(
          label: AppStrings.trackerAssignedUsers,
          icon: AppAssetsSvg.trackerProfileUsers,
          value: '12 assigned',
          opensAssignedUsers: true,
        ),
        TrackerProfileRowEntity(
          label: AppStrings.trackerActiveShareLinks,
          icon: AppAssetsSvg.trackerProfileShareLink,
          value: '2 active',
          valueColor: AppColors.trackerLinkLavender,
        ),
        TrackerProfileRowEntity(
          label: AppStrings.trackerReports,
          icon: AppAssetsSvg.trackerProfileReports,
        ),
      ],
    ),
    TrackerProfileSectionEntity(
      title: AppStrings.trackerSectionSecurity,
      rows: [
        TrackerProfileRowEntity(
          label: AppStrings.trackerSecuritySettings,
          icon: AppAssetsSvg.trackerProfileSecurity,
        ),
        TrackerProfileRowEntity(
          label: AppStrings.trackerTwoFactorAuth,
          icon: AppAssetsSvg.trackerProfileTwoFactor,
          value: 'Enabled',
        ),
      ],
    ),
    TrackerProfileSectionEntity(
      title: AppStrings.trackerSectionPreferences,
      rows: [
        TrackerProfileRowEntity(
          label: AppStrings.trackerNotificationSettings,
          icon: AppAssetsSvg.trackerProfileNotifications,
        ),
        TrackerProfileRowEntity(
          label: AppStrings.trackerDarkMode,
          icon: AppAssetsSvg.trackerProfileDarkMode,
          value: 'Always on',
        ),
      ],
    ),
    TrackerProfileSectionEntity(
      title: AppStrings.trackerSectionSubscription,
      rows: [
        TrackerProfileRowEntity(
          label: AppStrings.trackerPlanSubscription,
          icon: AppAssetsSvg.trackerProfileSubscription,
          value: AppStrings.trackerBadgeExpert,
          valueIsBadge: true,
        ),
      ],
    ),
    TrackerProfileSectionEntity(
      title: AppStrings.trackerSectionSupport,
      rows: [
        TrackerProfileRowEntity(
          label: AppStrings.trackerHelpSupport,
          icon: AppAssetsSvg.trackerProfileHelp,
        ),
      ],
    ),
  ];
}

final trackerProfileControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackerProfileController>(
  (ref) => TrackerProfileController(),
);
