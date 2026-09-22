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
        newPhoneController = TextEditingController(),
        currentPasswordController = TextEditingController(),
        newPasswordController = TextEditingController(),
        confirmNewPasswordController = TextEditingController();

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

  // --- Security settings ---------------------------------------------------

  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmNewPasswordController;

  bool twoFactorAuth = true;
  bool biometricLogin = true;

  void toggleTwoFactorAuth() {
    twoFactorAuth = !twoFactorAuth;
    notifyListeners();
  }

  void toggleBiometricLogin() {
    biometricLogin = !biometricLogin;
    notifyListeners();
  }

  // --- Notification settings -----------------------------------------------

  bool pushNotifications = true;
  bool emailChannel = true;
  bool smsChannel = false;
  bool alertSound = true;
  bool alertVibration = true;
  bool badgeCount = true;
  bool doNotDisturb = false;
  bool typeNewLogs = true;
  bool typeSyncAlerts = true;
  bool typeExport = true;
  bool typeSecurity = true;
  bool typeSystem = false;
  bool typeWeekly = true;

  void _set(void Function() change) {
    change();
    notifyListeners();
  }

  List<TrackerNotificationToggleEntity> get notificationChannels => [
        TrackerNotificationToggleEntity(
          title: AppStrings.trackerNotifPushTitle,
          note: AppStrings.trackerNotifPushNote,
          icon: AppAssetsSvg.trackerNotifPush,
          value: pushNotifications,
          onToggle: () => _set(() => pushNotifications = !pushNotifications),
        ),
        TrackerNotificationToggleEntity(
          title: AppStrings.trackerNotifEmailTitle,
          note: AppStrings.trackerNotifEmailNote,
          emoji: AppStrings.trackerNotifEmailEmoji,
          value: emailChannel,
          onToggle: () => _set(() => emailChannel = !emailChannel),
        ),
        TrackerNotificationToggleEntity(
          title: AppStrings.trackerNotifSmsTitle,
          note: AppStrings.trackerNotifSmsNote,
          emoji: AppStrings.trackerNotifSmsEmoji,
          value: smsChannel,
          onToggle: () => _set(() => smsChannel = !smsChannel),
        ),
      ];

  List<TrackerNotificationToggleEntity> get alertStyle => [
        TrackerNotificationToggleEntity(
          title: AppStrings.trackerNotifSoundTitle,
          icon: AppAssetsSvg.trackerNotifSound,
          value: alertSound,
          onToggle: () => _set(() => alertSound = !alertSound),
        ),
        TrackerNotificationToggleEntity(
          title: AppStrings.trackerNotifVibrationTitle,
          icon: AppAssetsSvg.trackerNotifVibration,
          value: alertVibration,
          onToggle: () => _set(() => alertVibration = !alertVibration),
        ),
        TrackerNotificationToggleEntity(
          title: AppStrings.trackerNotifBadgeTitle,
          emoji: AppStrings.trackerNotifBadgeEmoji,
          value: badgeCount,
          onToggle: () => _set(() => badgeCount = !badgeCount),
        ),
        TrackerNotificationToggleEntity(
          title: AppStrings.trackerNotifDndTitle,
          note: AppStrings.trackerNotifDndNote,
          icon: AppAssetsSvg.trackerNotifDnd,
          value: doNotDisturb,
          onToggle: () => _set(() => doNotDisturb = !doNotDisturb),
        ),
      ];

  List<TrackerNotificationToggleEntity> get notificationTypes => [
        TrackerNotificationToggleEntity(
          title: AppStrings.trackerNotifTypeNewLogs,
          value: typeNewLogs,
          onToggle: () => _set(() => typeNewLogs = !typeNewLogs),
        ),
        TrackerNotificationToggleEntity(
          title: AppStrings.trackerNotifTypeSyncAlerts,
          value: typeSyncAlerts,
          onToggle: () => _set(() => typeSyncAlerts = !typeSyncAlerts),
        ),
        TrackerNotificationToggleEntity(
          title: AppStrings.trackerNotifTypeExport,
          value: typeExport,
          onToggle: () => _set(() => typeExport = !typeExport),
        ),
        TrackerNotificationToggleEntity(
          title: AppStrings.trackerNotifTypeSecurity,
          value: typeSecurity,
          onToggle: () => _set(() => typeSecurity = !typeSecurity),
        ),
        TrackerNotificationToggleEntity(
          title: AppStrings.trackerNotifTypeSystem,
          value: typeSystem,
          onToggle: () => _set(() => typeSystem = !typeSystem),
        ),
        TrackerNotificationToggleEntity(
          title: AppStrings.trackerNotifTypeWeekly,
          value: typeWeekly,
          onToggle: () => _set(() => typeWeekly = !typeWeekly),
        ),
      ];

  // --- Display & theme -----------------------------------------------------

  TrackerThemeMode themeMode = TrackerThemeMode.dark;

  void setThemeMode(TrackerThemeMode mode) {
    if (themeMode == mode) return;
    themeMode = mode;
    notifyListeners();
  }

  final List<TrackerSessionEntity> sessions = const [
    TrackerSessionEntity(
      device: 'iPhone 14 Pro',
      location: 'New York, USA',
      lastActive: 'Active now',
      isCurrent: true,
    ),
    TrackerSessionEntity(
      device: 'MacBook Pro',
      location: 'New York, USA',
      lastActive: '2 hours ago',
    ),
    TrackerSessionEntity(
      device: 'iPad Air',
      location: 'Boston, MA',
      lastActive: '1 day ago',
    ),
  ];

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
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
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
