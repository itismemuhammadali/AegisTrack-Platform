import '../../../../../core/utils/app_exports.dart';
import '../../../authentication/domain/entities/tracked_subscription_plan_entity.dart';
import '../../domain/entities/tracked_payment_card_entity.dart';
import '../../domain/entities/tracked_sync_log_entry_entity.dart';

class TrackedSettingsController extends ChangeNotifier with Buffers {
  TrackedSettingsController()
      : nameController =
            TextEditingController(text: AppStrings.trackedSettingsProfileName),
        emailController =
            TextEditingController(text: AppStrings.trackedEditProfileEmailHint),
        phoneController =
            TextEditingController(text: AppStrings.trackedEditProfilePhoneHint);

  bool backgroundTrackingEnabled = true;
  bool autoSyncEnabled = true;

  // Edit profile - Joshua R Hughes (location tracking)
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  File? avatarPhoto;
  bool isSavingProfile = false;

  final int exportReadyLogsCount = 15;
  final List<TrackedExportFormat> exportFormats = TrackedExportFormat.values;

  List<TrackedSyncLogEntryEntity> _syncLogEntries = const [
    TrackedSyncLogEntryEntity(
      coordinates: '37.7749° N, 122.4194° W',
      timestamp: '2 min ago',
      status: TrackedSyncLogStatus.pending,
    ),
    TrackedSyncLogEntryEntity(
      coordinates: '37.7750° N, 122.4195° W',
      timestamp: '5 min ago',
      status: TrackedSyncLogStatus.pending,
    ),
    TrackedSyncLogEntryEntity(
      coordinates: '37.7748° N, 122.4193° W',
      timestamp: '8 min ago',
      status: TrackedSyncLogStatus.pending,
    ),
    TrackedSyncLogEntryEntity(
      coordinates: '37.7751° N, 122.4196° W',
      timestamp: '15 min ago',
      status: TrackedSyncLogStatus.failed,
      failureReason: 'Network timeout',
    ),
    TrackedSyncLogEntryEntity(
      coordinates: '37.7752° N, 122.4197° W',
      timestamp: '1 hour ago',
      status: TrackedSyncLogStatus.synced,
    ),
    TrackedSyncLogEntryEntity(
      coordinates: '37.7753° N, 122.4198° W',
      timestamp: '2 hours ago',
      status: TrackedSyncLogStatus.synced,
    ),
    TrackedSyncLogEntryEntity(
      coordinates: '37.7754° N, 122.4199° W',
      timestamp: '3 hours ago',
      status: TrackedSyncLogStatus.synced,
    ),
  ];

  List<TrackedSyncLogEntryEntity> get syncLogEntries => _syncLogEntries;

  List<TrackedSyncLogEntryEntity> get pendingEntries => _syncLogEntries
      .where((entry) => entry.status == TrackedSyncLogStatus.pending)
      .toList();

  List<TrackedSyncLogEntryEntity> get failedEntries => _syncLogEntries
      .where((entry) => entry.status == TrackedSyncLogStatus.failed)
      .toList();

  List<TrackedSyncLogEntryEntity> get syncedEntries => _syncLogEntries
      .where((entry) => entry.status == TrackedSyncLogStatus.synced)
      .toList();

  void setBackgroundTracking(bool value) {
    if (backgroundTrackingEnabled == value) return;
    backgroundTrackingEnabled = value;
    notifyListeners();
  }

  void setAutoSync(bool value) {
    if (autoSyncEnabled == value) return;
    autoSyncEnabled = value;
    notifyListeners();
  }

  void retrySync(TrackedSyncLogEntryEntity entry) {
    final index = _syncLogEntries.indexOf(entry);
    if (index == -1) return;

    _syncLogEntries = [
      for (var i = 0; i < _syncLogEntries.length; i++)
        if (i == index)
          TrackedSyncLogEntryEntity(
            coordinates: entry.coordinates,
            timestamp: entry.timestamp,
            status: TrackedSyncLogStatus.synced,
          )
        else
          _syncLogEntries[i],
    ];
    notifyListeners();
  }

  void syncNow() {
    _syncLogEntries = [
      for (final entry in _syncLogEntries)
        if (entry.status == TrackedSyncLogStatus.pending)
          TrackedSyncLogEntryEntity(
            coordinates: entry.coordinates,
            timestamp: entry.timestamp,
            status: TrackedSyncLogStatus.synced,
          )
        else
          entry,
    ];
    notifyListeners();
  }

  void exportFormat(TrackedExportFormat format) {
    Prompts.showToast(_exportConfirmationMessage(format));
  }

  String _exportConfirmationMessage(TrackedExportFormat format) =>
      switch (format) {
        TrackedExportFormat.encryptedPdf =>
          AppStrings.trackedExportCenterPdfConfirmation,
        TrackedExportFormat.spreadsheet =>
          AppStrings.trackedExportCenterSpreadsheetConfirmation,
        TrackedExportFormat.email =>
          AppStrings.trackedExportCenterEmailConfirmation,
      };

  void setAvatarPhoto(File? file) {
    avatarPhoto = file;
    notifyListeners();
  }

  Future<void> saveProfile({VoidCallback? onSaved}) async {
    if (isSavingProfile) return;
    isSavingProfile = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    isSavingProfile = false;
    notifyListeners();
    onSaved?.call();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> logout() async {
    await AuthHandler.ref.logout();
    AppRouterGo.pushRemoveUntil(signInView);
  }

  // Membership - Joshua R Hughes (location tracking)
  TrackedSubscriptionPlan currentPlan = TrackedSubscriptionPlan.basic;
  List<TrackedPaymentCardEntity> paymentCards = const [
    TrackedPaymentCardEntity(
      brand: 'Visa',
      last4: '4242',
      expiry: '12/27',
      isDefault: true,
    ),
    TrackedPaymentCardEntity(
      brand: 'Mastercard',
      last4: '5555',
      expiry: '09/26',
    ),
  ];

  void changePlan(TrackedSubscriptionPlan plan) {
    if (currentPlan == plan) return;
    currentPlan = plan;
    notifyListeners();
  }

  /// Adds a card locally. tokenize via the payment provider instead.
  void addCard({required String number, required String expiry}) {
    final digits = number.replaceAll(RegExp(r'\D'), '');
    final brand = switch (digits.isEmpty ? '' : digits[0]) {
      '4' => 'Visa',
      '5' || '2' => 'Mastercard',
      '3' => 'Amex',
      _ => 'Card',
    };
    paymentCards = [
      ...paymentCards,
      TrackedPaymentCardEntity(
        brand: brand,
        last4: digits.substring(digits.length - 4),
        expiry: expiry,
        isDefault: paymentCards.isEmpty,
      ),
    ];
    notifyListeners();
  }

  void setDefaultCard(TrackedPaymentCardEntity card) {
    paymentCards = [
      for (final c in paymentCards) c.copyWith(isDefault: identical(c, card)),
    ];
    notifyListeners();
  }

  void removeCard(TrackedPaymentCardEntity card) {
    final wasDefault = card.isDefault;
    paymentCards = [
      for (final c in paymentCards)
        if (!identical(c, card)) c,
    ];
    if (wasDefault && paymentCards.isNotEmpty) {
      paymentCards = [
        paymentCards.first.copyWith(isDefault: true),
        ...paymentCards.skip(1),
      ];
    }
    notifyListeners();
  }
}

final trackedSettingsControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackedSettingsController>(
  (ref) => TrackedSettingsController(),
);
