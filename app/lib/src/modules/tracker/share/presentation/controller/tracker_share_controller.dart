import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_share_entity.dart';

/// Drives the four-step Secure Share wizard. Figma sample data; replace with
/// the viewer share API.
class TrackerShareController extends ChangeNotifier with Buffers {
  static const int stepCount = 4;

  /// 0-based: content, expiry, review, created.
  int step = 0;

  int selectedContent = 0;
  int selectedExpiry = 1;

  /// Whether the All Links list below the created card is expanded.
  bool showAllLinks = false;

  bool get isFirstStep => step == 0;

  bool get isCreated => step == stepCount - 1;

  void next() {
    if (step >= stepCount - 1) return;
    step++;
    notifyListeners();
  }

  void back() {
    if (step == 0) return;
    step--;
    notifyListeners();
  }

  DateTime? startDate;
  DateTime? endDate;

  void setStartDate(DateTime date) {
    startDate = date;
    if (endDate != null && endDate!.isBefore(date)) endDate = null;
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    endDate = date;
    notifyListeners();
  }

  void selectContent(int index) {
    if (selectedContent == index) return;
    selectedContent = index;
    notifyListeners();
  }

  void selectExpiry(int index) {
    if (selectedExpiry == index) return;
    selectedExpiry = index;
    notifyListeners();
  }

  void toggleAllLinks() {
    showAllLinks = !showAllLinks;
    notifyListeners();
  }

  /// Returns to the first step with the previous choices kept, so creating a
  /// second link does not mean re-picking everything.
  void createAnother() {
    step = 0;
    showAllLinks = false;
    notifyListeners();
  }

  final List<TrackerShareOptionEntity> contentOptions = const [
    TrackerShareOptionEntity(
      title: AppStrings.trackerShareRecentActivity,
      subtitle: AppStrings.trackerShareRecentActivityNote,
      icon: AppAssetsSvg.trackerShareRecent,
    ),
    TrackerShareOptionEntity(
      title: AppStrings.trackerShareLiveActivity,
      subtitle: AppStrings.trackerShareLiveActivityNote,
      icon: AppAssetsSvg.trackerShareLive,
      badge: AppStrings.trackerShareExpertBadge,
    ),
  ];

  final List<TrackerShareOptionEntity> expiryOptions = const [
    TrackerShareOptionEntity(
      title: AppStrings.trackerShareExpiry1Hour,
      subtitle: AppStrings.trackerShareExpiry1HourNote,
    ),
    TrackerShareOptionEntity(
      title: AppStrings.trackerShareExpiry24Hours,
      subtitle: AppStrings.trackerShareExpiry24HoursNote,
    ),
    TrackerShareOptionEntity(
      title: AppStrings.trackerShareExpiry7Days,
      subtitle: AppStrings.trackerShareExpiry7DaysNote,
    ),
    TrackerShareOptionEntity(
      title: AppStrings.trackerShareExpiryCustom,
      subtitle: AppStrings.trackerShareExpiryCustomNote,
    ),
  ];

  /// Echoes the wizard's choices back before the link is cut.
  List<TrackerShareReviewEntity> get reviewRows => [
        TrackerShareReviewEntity(
          icon: AppAssetsSvg.trackerShareContent,
          label: AppStrings.trackerShareReviewContent,
          value: selectedContent == 0
              ? 'Recent Activity · Dec 6–12, 2024'
              : 'Live Activity · Daniel Chen',
        ),
        TrackerShareReviewEntity(
          icon: AppAssetsSvg.trackerShareClock,
          label: AppStrings.trackerShareReviewExpiry,
          value: _expirySummary,
        ),
        const TrackerShareReviewEntity(
          icon: AppAssetsSvg.trackerShareAccess,
          label: AppStrings.trackerShareReviewAccess,
          value: AppStrings.trackerShareReadOnlyValue,
        ),
        const TrackerShareReviewEntity(
          icon: AppAssetsSvg.trackerShareEncryption,
          label: AppStrings.trackerShareReviewEncryption,
          value: AppStrings.trackerShareEncryptedValue,
          valueColor: AppColors.trackerOnlineGreen,
        ),
      ];

  static const List<String> _expirySummaries = [
    '1 hour · Expires Dec 12 at 15:30',
    '24 hours · Expires Dec 13 at 14:30',
    '7 days · Expires Dec 19 at 14:30',
    'Custom · Set on creation',
  ];

  String get _expirySummary => _expirySummaries[selectedExpiry];

  final String createdUrl = 'https://share.securetrack.io/v/••••••';
  final String createdAt = 'Dec 12, 2024 14:32';
  final String expiresAt = 'Dec 13, 2024 14:32';

  final List<TrackerShareLinkEntity> links = const [
    TrackerShareLinkEntity(
      url: 'https://share.securetrack.io/v/a1b2c3••••',
      description: 'Recent Activity · Dec 6–12, 2024',
      expires: 'Dec 13, 2024 14:32',
      status: TrackerShareLinkStatus.active,
    ),
    TrackerShareLinkEntity(
      url: 'https://share.securetrack.io/v/d4e5f6••••',
      description: 'Live Activity · Daniel Chen',
      expires: 'Dec 11, 2024 09:00',
      status: TrackerShareLinkStatus.expired,
    ),
    TrackerShareLinkEntity(
      url: 'https://share.securetrack.io/v/g7h8i9••••',
      description: 'Recent Activity · Dec 1–7, 2024',
      expires: 'Dec 8, 2024 18:00',
      status: TrackerShareLinkStatus.revoked,
    ),
  ];
}

final trackerShareControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackerShareController>(
  (ref) => TrackerShareController(),
);
