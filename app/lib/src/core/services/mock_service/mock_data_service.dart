import '../../utils/app_exports.dart';
import '../../../modules/tracked/logs/domain/entities/tracked_log_entry_entity.dart';
import '../../../modules/tracker/cases/domain/entities/tracker_case_entity.dart';
import '../../../modules/tracker/home/domain/entities/tracker_user_entity.dart';

/// Centralized Mock Data & State Service for Offline Simulation.
/// Allows all screens (Tracked and Tracker) to function with rich, realistic,
/// reactive data without requiring live Firebase or cloud credentials.
class MockDataService extends ChangeNotifier {
  // --- Current User Profiles ---
  String trackedUserName = "Johnathan Vance";
  String trackedUserEmail = "j.vance@client-mail.com";
  String trackedUserPhone = "+1 (512) 555-0194";
  String trackedUserCaseNumber = "#CR-2026-9912";
  String trackedUserSupervisor = "Joshua R. Hughes, Esq.";
  bool isTrackedOnline = true;
  bool isMockGpsDetected = false;
  int batteryLevel = 88;
  int pendingOfflineSyncCount = 0;

  // --- Tracker / Viewer Profile ---
  String trackerName = "Joshua R. Hughes, Esq.";
  String trackerEmail = "joshua@hugheslegal.com";
  String trackerFirm = "Hughes Criminal Defense & Legal Monitoring";
  String trackerPhone = "+1 (512) 800-4844";

  // --- Tracked Logs List ---
  final List<TrackedLogEntryEntity> _trackedLogs = [
    const TrackedLogEntryEntity(
      location: "800 Congress Ave, Austin, TX",
      timestamp: "10:15 AM Today",
      status: TrackedLogStatus.synced,
      tags: ["Workplace", "Inclusion Zone"],
    ),
    const TrackedLogEntryEntity(
      location: "1100 Colorado St, Austin, TX",
      timestamp: "08:45 AM Today",
      status: TrackedLogStatus.synced,
      tags: ["Courthouse", "Check-in"],
    ),
    const TrackedLogEntryEntity(
      location: "2400 E 7th St, Austin, TX",
      timestamp: "Yesterday 11:30 PM",
      status: TrackedLogStatus.synced,
      tags: ["Residence", "Curfew Active"],
    ),
    const TrackedLogEntryEntity(
      location: "1500 S Lamar Blvd, Austin, TX",
      timestamp: "Yesterday 06:15 PM",
      status: TrackedLogStatus.synced,
      tags: ["Transit"],
    ),
    const TrackedLogEntryEntity(
      location: "300 W 6th St, Austin, TX",
      timestamp: "Yesterday 01:20 PM",
      status: TrackedLogStatus.synced,
      tags: ["Legal Consultation"],
    ),
  ];

  List<TrackedLogEntryEntity> get trackedLogs => List.unmodifiable(_trackedLogs);

  // --- Tracker Assigned Cases ---
  final List<TrackerCaseEntity> _trackerCases = [
    const TrackerCaseEntity(
      id: "case_9912",
      title: "State vs. Johnathan Vance",
      status: "Active Monitoring",
      statusColor: AppColors.trackerOnlineGreen,
      people: [
        TrackerCasePersonEntity(initials: "JV", name: "Johnathan Vance"),
      ],
      evidence: "142 Logs Sealed",
      date: "Oct 01, 2026",
      legalHold: true,
    ),
    const TrackerCaseEntity(
      id: "case_8840",
      title: "Marcus Sterling (Bail Supervision)",
      status: "Active Monitoring",
      statusColor: AppColors.trackerOnlineGreen,
      people: [
        TrackerCasePersonEntity(initials: "MS", name: "Marcus Sterling"),
      ],
      evidence: "89 Logs Sealed",
      date: "Sep 28, 2026",
      legalHold: false,
    ),
    const TrackerCaseEntity(
      id: "case_1102",
      title: "Elena Rostova (Travel Compliance)",
      status: "Boundary Warning",
      statusColor: AppColors.trackerOrange,
      people: [
        TrackerCasePersonEntity(initials: "ER", name: "Elena Rostova"),
      ],
      evidence: "64 Logs Sealed",
      date: "Oct 03, 2026",
      legalHold: true,
    ),
  ];

  List<TrackerCaseEntity> get trackerCases => List.unmodifiable(_trackerCases);

  // --- Tracker Monitored Users ---
  final List<TrackerUserEntity> _trackerUsers = [
    const TrackerUserEntity(
      name: "Johnathan Vance",
      lastSeen: "2 mins ago",
      location: "800 Congress Ave, Austin, TX",
      authenticity: TrackerAuthenticity.verified,
      score: "98",
      trend: "Stable",
      activeAlerts: "0",
      missedCheckIns: "0",
      zoneEvents: "2 today",
      securityFlags: "0",
    ),
    const TrackerUserEntity(
      name: "Marcus Sterling",
      lastSeen: "14 mins ago",
      location: "I-35 Northbound, Mile 242",
      authenticity: TrackerAuthenticity.acceptable,
      score: "86",
      trend: "In Transit",
      activeAlerts: "1",
      missedCheckIns: "0",
      zoneEvents: "3 today",
      securityFlags: "0",
    ),
    const TrackerUserEntity(
      name: "Elena Rostova",
      lastSeen: "45 mins ago",
      location: "Westlake Hills, Austin, TX",
      authenticity: TrackerAuthenticity.questionable,
      score: "78",
      trend: "Border Warning",
      activeAlerts: "2",
      missedCheckIns: "1",
      zoneEvents: "5 today",
      securityFlags: "1",
    ),
  ];

  List<TrackerUserEntity> get trackerUsers => List.unmodifiable(_trackerUsers);

  // --- Check-In History Records ---
  final List<Map<String, dynamic>> _checkIns = [
    {
      "id": "chk_01",
      "timestamp": "10:00 AM Today",
      "location": "800 Congress Ave, Austin, TX",
      "similarityScore": 99.2,
      "livenessVerified": true,
      "status": "APPROVED",
      "imageUrl": AppAssetsPng.trackerUserAvatar,
    },
    {
      "id": "chk_02",
      "timestamp": "06:00 PM Yesterday",
      "location": "2400 E 7th St, Austin, TX",
      "similarityScore": 98.4,
      "livenessVerified": true,
      "status": "APPROVED",
      "imageUrl": AppAssetsPng.trackerUserAvatar,
    },
    {
      "id": "chk_03",
      "timestamp": "09:15 AM Yesterday",
      "location": "1100 Colorado St, Austin, TX",
      "similarityScore": 97.9,
      "livenessVerified": true,
      "status": "APPROVED",
      "imageUrl": AppAssetsPng.trackerUserAvatar,
    },
  ];

  List<Map<String, dynamic>> get checkIns => List.unmodifiable(_checkIns);

  // --- Generated Case Reports ---
  final List<TrackerCaseReportEntity> _caseReports = [
    const TrackerCaseReportEntity(
      title: "Court Evidentiary Log #CR-2026-9912 (Oct 01 - Oct 07)",
      generated: "Generated today at 09:30 AM • Certified PDF",
    ),
    const TrackerCaseReportEntity(
      title: "Weekly Compliance Summary (Sep 24 - Sep 30)",
      generated: "Generated Sep 30, 2026 • Certified PDF",
    ),
    const TrackerCaseReportEntity(
      title: "Full Raw Location Audit Trail (.XLSX)",
      generated: "Generated Sep 28, 2026 • Excel Export",
    ),
  ];

  List<TrackerCaseReportEntity> get caseReports => List.unmodifiable(_caseReports);

  // --- Mutation Actions ---

  /// Add a new location log
  void addLog({
    required String location,
    required String timestamp,
    required TrackedLogStatus status,
    List<String> tags = const [],
  }) {
    _trackedLogs.insert(
      0,
      TrackedLogEntryEntity(
        location: location,
        timestamp: timestamp,
        status: status,
        tags: tags,
      ),
    );
    notifyListeners();
  }

  /// Add a new selfie check-in
  void addCheckIn({
    required String location,
    required double similarityScore,
    bool livenessVerified = true,
  }) {
    _checkIns.insert(0, {
      "id": "chk_${DateTime.now().millisecondsSinceEpoch}",
      "timestamp": "Just now",
      "location": location,
      "similarityScore": similarityScore,
      "livenessVerified": livenessVerified,
      "status": "APPROVED",
      "imageUrl": AppAssetsPng.trackerUserAvatar,
    });
    notifyListeners();
  }

  /// Emergency SOS broadcast
  void triggerSosAlert() {
    addLog(
      location: "EMERGENCY SOS: 800 Congress Ave, Austin, TX",
      timestamp: "Immediate Alert",
      status: TrackedLogStatus.synced,
      tags: ["CRITICAL", "SOS BROADCAST"],
    );
  }

  /// Update Tracked profile information
  void updateTrackedProfile({
    required String name,
    required String phone,
  }) {
    trackedUserName = name;
    trackedUserPhone = phone;
    notifyListeners();
  }

  /// Trigger offline sync queue drainage
  Future<void> syncOfflineQueue() async {
    pendingOfflineSyncCount = 0;
    notifyListeners();
  }

  /// Generate and append a new court report
  void addGeneratedReport({required String title, required String format}) {
    _caseReports.insert(
      0,
      TrackerCaseReportEntity(
        title: title,
        generated: "Generated just now • Certified $format",
      ),
    );
    notifyListeners();
  }
}

/// Global provider for MockDataService
final mockDataServiceProvider = ChangeNotifierProvider<MockDataService>(
  (ref) => MockDataService(),
);
