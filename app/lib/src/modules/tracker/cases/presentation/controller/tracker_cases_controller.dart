import '../../../../../core/utils/app_exports.dart';
import '../../../home/domain/entities/tracker_user_entity.dart';
import '../../domain/entities/tracker_case_entity.dart';

/// Figma sample records; replace with the viewer case API.
class TrackerCasesController extends ChangeNotifier with Buffers {
  TrackerCasesController() {
    locator<MockDataService>().addListener(_onMockDataChanged);
  }

  void _onMockDataChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    locator<MockDataService>().removeListener(_onMockDataChanged);
    super.dispose();
  }

  List<TrackerCaseEntity> get cases => locator<MockDataService>().trackerCases;

  /// The SOS card opens an overview for an unidentified subject: the alert
  /// carries a position but no verified history behind it.
  static const TrackerUserEntity sosSubject = TrackerUserEntity(
    name: AppStrings.trackerUnknownUser,
    lastSeen: '',
    location: '',
    authenticity: TrackerAuthenticity.suspect,
    isIdentified: false,
  );

  // --- Case detail ---------------------------------------------------------

  static const List<String> detailTabs = [
    AppStrings.trackerCaseTabTimeline,
    AppStrings.trackerCaseTabEvidence,
    AppStrings.trackerCaseTabReports,
  ];

  String detailTab = AppStrings.trackerCaseTabTimeline;

  void setDetailTab(String tab) {
    if (detailTab == tab) return;
    detailTab = tab;
    notifyListeners();
  }

  final List<TrackerCaseInfoEntity> caseInfo = const [
    TrackerCaseInfoEntity(
        label: AppStrings.trackerCaseType, value: 'Monitoring & Compliance'),
    TrackerCaseInfoEntity(
        label: AppStrings.trackerCaseJurisdiction, value: 'New York, USA'),
    TrackerCaseInfoEntity(
        label: AppStrings.trackerCaseOpened, value: 'Jan 15, 2024'),
    TrackerCaseInfoEntity(
        label: AppStrings.trackerCaseAuthorizedViewers,
        value: 'Admin, Legal Team, Supervisor'),
  ];

  final List<TrackerCaseSubjectEntity> caseSubjects = const [
    TrackerCaseSubjectEntity(
      initials: 'DC',
      name: 'Daniel Chen',
      role: AppStrings.trackerCaseMonitoredSubject,
      score: '94',
      scoreColor: AppColors.trackerOnlineGreen,
    ),
    TrackerCaseSubjectEntity(
      initials: 'SM',
      name: 'Sarah Martinez',
      role: AppStrings.trackerCaseMonitoredSubject,
      score: '88',
      scoreColor: AppColors.trackerAcceptableText,
    ),
  ];

  final List<TrackerCaseEvidenceStatEntity> evidenceStats = const [
    TrackerCaseEvidenceStatEntity(
        icon: AppAssetsSvg.trackerCaseDetailLogs,
        value: '48',
        label: AppStrings.trackerCaseStatLogs),
    TrackerCaseEvidenceStatEntity(
        icon: AppAssetsSvg.trackerCaseDetailCheckIns,
        value: '12',
        label: AppStrings.trackerCaseStatCheckIns),
    TrackerCaseEvidenceStatEntity(
        icon: AppAssetsSvg.trackerCaseDetailZone,
        value: '3',
        label: AppStrings.trackerCaseStatZoneEvents),
    TrackerCaseEvidenceStatEntity(
        icon: AppAssetsSvg.trackerCaseDetailSos,
        value: '2',
        label: AppStrings.trackerCaseStatSosEvents),
    TrackerCaseEvidenceStatEntity(
        icon: AppAssetsSvg.trackerCaseDetailFlags,
        value: '0',
        label: AppStrings.trackerCaseStatSecurityFlags),
    TrackerCaseEvidenceStatEntity(
        icon: AppAssetsSvg.trackerCaseDetailReports,
        value: '5',
        label: AppStrings.trackerCaseStatReports),
  ];

  final List<TrackerCaseEventEntity> caseEvents = const [
    TrackerCaseEventEntity(
      timestamp: 'Dec 12, 2024 · 14:32',
      kind: TrackerCaseEventKind.checkIn,
      name: 'Daniel Chen',
      location: 'Office Building, NY',
      authScore: '96/100',
      authColor: AppColors.trackerOnlineGreen,
    ),
    TrackerCaseEventEntity(
      timestamp: 'Dec 11, 2024 · 09:14',
      kind: TrackerCaseEventKind.zoneEvent,
      name: 'Sarah Martinez',
      location: 'Restricted Area B',
      authScore: '82/100',
      authColor: AppColors.trackerAcceptableText,
    ),
    TrackerCaseEventEntity(
      timestamp: 'Dec 10, 2024 · 17:05',
      kind: TrackerCaseEventKind.locationUpdate,
      name: 'Daniel Chen',
      location: 'Financial District, NY',
      authScore: '91/100',
      authColor: AppColors.trackerOnlineGreen,
    ),
    TrackerCaseEventEntity(
      timestamp: 'Dec 9, 2024 · 08:50',
      kind: TrackerCaseEventKind.checkIn,
      name: 'Sarah Martinez',
      location: 'Uptown Office, NY',
      authScore: '94/100',
      authColor: AppColors.trackerOnlineGreen,
    ),
    TrackerCaseEventEntity(
      timestamp: 'Dec 8, 2024 · 13:20',
      kind: TrackerCaseEventKind.sosEvent,
      name: 'Daniel Chen',
      location: 'Midtown, NY',
      authScore: '78/100',
      authColor: AppColors.trackerAcceptableText,
    ),
  ];

  final List<TrackerCaseEvidenceEntity> caseEvidence = const [
    TrackerCaseEvidenceEntity(
      logId: 'LG-2024-8821',
      kind: TrackerCaseEventKind.checkIn,
      score: '96/100',
      scoreColor: AppColors.trackerOnlineGreen,
    ),
    TrackerCaseEvidenceEntity(
      logId: 'LG-2024-8756',
      kind: TrackerCaseEventKind.zoneEvent,
      score: '82/100',
      scoreColor: AppColors.trackerAcceptableText,
    ),
    TrackerCaseEvidenceEntity(
      logId: 'LG-2024-8701',
      kind: TrackerCaseEventKind.locationUpdate,
      score: '91/100',
      scoreColor: AppColors.trackerOnlineGreen,
    ),
    TrackerCaseEvidenceEntity(
      logId: 'LG-2024-8644',
      kind: TrackerCaseEventKind.checkIn,
      score: '94/100',
      scoreColor: AppColors.trackerOnlineGreen,
    ),
    TrackerCaseEvidenceEntity(
      logId: 'LG-2024-8590',
      kind: TrackerCaseEventKind.sosEvent,
      score: '78/100',
      scoreColor: AppColors.trackerAcceptableText,
    ),
  ];

  List<TrackerCaseReportEntity> get caseReports => locator<MockDataService>().caseReports;

  bool get showsTimeline => detailTab == AppStrings.trackerCaseTabTimeline;

  bool get showsEvidence => detailTab == AppStrings.trackerCaseTabEvidence;

  bool get showsReports => detailTab == AppStrings.trackerCaseTabReports;

  final String sosName = 'Lisa Park';
  final String sosInitials = 'LP';
  final String sosLocation = 'Financial District';
  final String sosTime = '30 sec ago';
}

final trackerCasesControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackerCasesController>(
  (ref) => TrackerCasesController(),
);
