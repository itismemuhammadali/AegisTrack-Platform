import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_profile_row_entity.dart';

/// Figma sample profile; replace with the viewer account API.
class TrackerProfileController extends ChangeNotifier with Buffers {
  TrackerProfileController()
      : nameController =
            TextEditingController(text: AppStrings.trackerProfileName),
        usernameController = TextEditingController(
            text: AppStrings.trackerEditProfileUsernameValue),
        bioController =
            TextEditingController(text: AppStrings.trackerEditProfileBioValue),
        locationController = TextEditingController(
            text: AppStrings.trackerEditProfileLocationValue),
        newEmailController = TextEditingController(),
        confirmPasswordController = TextEditingController(),
        newPhoneController = TextEditingController();

  final String name = AppStrings.trackerProfileName;
  final String email = AppStrings.trackerProfileEmail;

  // --- Edit profile --------------------------------------------------------

  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController bioController;
  final TextEditingController locationController;

  // --- Email settings ------------------------------------------------------

  final TextEditingController newEmailController;
  final TextEditingController confirmPasswordController;

  /// Email preference switches, all on in the design.
  bool emailNotifications = true;
  bool weeklyReports = true;
  bool securityAlerts = true;

  void toggleEmailNotifications() {
    emailNotifications = !emailNotifications;
    notifyListeners();
  }

  void toggleWeeklyReports() {
    weeklyReports = !weeklyReports;
    notifyListeners();
  }

  void toggleSecurityAlerts() {
    securityAlerts = !securityAlerts;
    notifyListeners();
  }

  // --- Phone number --------------------------------------------------------

  final TextEditingController newPhoneController;

  final String phone = AppStrings.trackerPhoneCurrentValue;

  bool smsNotifications = true;
  bool smsTwoFactor = false;

  void toggleSmsNotifications() {
    smsNotifications = !smsNotifications;
    notifyListeners();
  }

  void toggleSmsTwoFactor() {
    smsTwoFactor = !smsTwoFactor;
    notifyListeners();
  }

  /// Initials for the avatar, taken from whatever the name field holds.
  String get initials => nameController.text
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    bioController.dispose();
    locationController.dispose();
    newEmailController.dispose();
    confirmPasswordController.dispose();
    newPhoneController.dispose();
    super.dispose();
  }

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

  // --- Help & support ------------------------------------------------------

  final List<TrackerHelpChannelEntity> helpChannels = const [
    TrackerHelpChannelEntity(
      icon: AppAssetsSvg.trackerHelpChat,
      iconFill: AppColors.trackerHelpChatFill,
      title: AppStrings.trackerHelpLiveChat,
      subtitle: AppStrings.trackerHelpLiveChatSubtitle,
    ),
    TrackerHelpChannelEntity(
      icon: AppAssetsSvg.trackerHelpEmail,
      iconFill: AppColors.trackerHelpEmailFill,
      title: AppStrings.trackerHelpEmailSupport,
      subtitle: AppStrings.trackerHelpSupportEmail,
    ),
    TrackerHelpChannelEntity(
      icon: AppAssetsSvg.trackerHelpDocs,
      iconFill: AppColors.trackerHelpDocsFill,
      title: AppStrings.trackerHelpDocumentation,
      subtitle: AppStrings.trackerHelpDocumentationSubtitle,
    ),
    TrackerHelpChannelEntity(
      icon: AppAssetsSvg.trackerHelpStatus,
      iconFill: AppColors.trackerHelpStatusFill,
      title: AppStrings.trackerHelpStatusPage,
      subtitle: AppStrings.trackerHelpStatusPageSubtitle,
    ),
  ];

  final List<String> helpQuickReference = const [
    AppStrings.trackerHelpTipReadOnly,
    AppStrings.trackerHelpTipAuthenticity,
    AppStrings.trackerHelpTipAiSummaries,
    AppStrings.trackerHelpTipShareLinks,
    AppStrings.trackerHelpTipImmutable,
  ];

  final List<String> helpFaqs = const [
    AppStrings.trackerHelpFaqReadOnly,
    AppStrings.trackerHelpFaqRequestAccess,
    AppStrings.trackerHelpFaqAuthenticityScore,
    AppStrings.trackerHelpFaqEncryption,
    AppStrings.trackerHelpFaqLegalTeam,
  ];

  // --- Plan & subscription -------------------------------------------------

  static const List<String> planTiers = [
    AppStrings.trackerPlanColumnFree,
    AppStrings.trackerPlanColumnBasic,
    AppStrings.trackerPlanColumnPro,
    AppStrings.trackerPlanColumnExpert,
  ];

  final List<TrackerPlanFeatureEntity> planFeatures = const [
    TrackerPlanFeatureEntity(
        label: AppStrings.trackerPlanFeatureLocalStorage,
        tiers: [true, true, true, true]),
    TrackerPlanFeatureEntity(
        label: AppStrings.trackerPlanFeatureServerStorage,
        tiers: [false, true, true, true]),
    TrackerPlanFeatureEntity(
        label: AppStrings.trackerPlanFeatureAntiSpoofing,
        tiers: [false, true, true, true]),
    TrackerPlanFeatureEntity(
        label: AppStrings.trackerPlanFeatureAuthenticity,
        tiers: [false, true, true, true]),
    TrackerPlanFeatureEntity(
        label: AppStrings.trackerPlanFeatureViewerAccess,
        tiers: [false, false, true, true]),
    TrackerPlanFeatureEntity(
        label: AppStrings.trackerPlanFeatureMapPlayback,
        tiers: [false, false, true, true]),
    TrackerPlanFeatureEntity(
        label: AppStrings.trackerPlanFeatureGeofencing,
        tiers: [false, false, true, true]),
    TrackerPlanFeatureEntity(
        label: AppStrings.trackerPlanFeatureCases,
        tiers: [false, false, true, true]),
    TrackerPlanFeatureEntity(
        label: AppStrings.trackerPlanFeatureAiInsights,
        tiers: [false, true, false, true]),
    TrackerPlanFeatureEntity(
        label: AppStrings.trackerPlanFeatureLiveTracking,
        tiers: [false, false, false, true]),
    TrackerPlanFeatureEntity(
        label: AppStrings.trackerPlanFeatureShareLinks,
        tiers: [false, false, false, true]),
    TrackerPlanFeatureEntity(
        label: AppStrings.trackerPlanFeatureCheckIns,
        tiers: [false, false, false, true]),
    TrackerPlanFeatureEntity(
        label: AppStrings.trackerPlanFeatureAdvancedAi,
        tiers: [false, false, false, true]),
  ];

  /// Which FAQ is open, or null while they are all collapsed. The design only
  /// shows the collapsed state, so an answer body is not modelled yet.
  String? expandedFaq;

  void toggleFaq(String question) {
    expandedFaq = expandedFaq == question ? null : question;
    notifyListeners();
  }
}

final trackerProfileControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackerProfileController>(
  (ref) => TrackerProfileController(),
);
