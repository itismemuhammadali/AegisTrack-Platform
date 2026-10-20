import 'package:flutter_test/flutter_test.dart';
import 'package:joshua_r_hughes/src/core/services/mock_service/mock_data_service.dart';
import 'package:joshua_r_hughes/src/core/utils/app_enums.dart';

void main() {
  group('MockDataService Unit & State Transition Tests', () {
    late MockDataService service;

    setUp(() {
      service = MockDataService();
    });

    test('Initial state contains pre-seeded realistic legal monitoring data', () {
      expect(service.trackedUserName, equals('Johnathan Vance'));
      expect(service.trackedLogs.isNotEmpty, isTrue);
      expect(service.trackerCases.isNotEmpty, isTrue);
      expect(service.trackerUsers.isNotEmpty, isTrue);
      expect(service.checkIns.isNotEmpty, isTrue);
      expect(service.caseReports.isNotEmpty, isTrue);
    });

    test('addLog inserts new entry at top and notifies listeners', () {
      var notified = false;
      service.addListener(() => notified = true);

      final initialCount = service.trackedLogs.length;
      service.addLog(
        location: '100 Congress Ave, Austin, TX',
        timestamp: 'Just now',
        status: TrackedLogStatus.synced,
        tags: ['Court Hearing', 'Sealed'],
      );

      expect(service.trackedLogs.length, equals(initialCount + 1));
      expect(service.trackedLogs.first.location, equals('100 Congress Ave, Austin, TX'));
      expect(notified, isTrue);
    });

    test('addCheckIn inserts verified check-in record and notifies listeners', () {
      var notified = false;
      service.addListener(() => notified = true);

      final initialCount = service.checkIns.length;
      service.addCheckIn(
        location: 'Travis County Courthouse, Austin, TX',
        similarityScore: 99.4,
        livenessVerified: true,
      );

      expect(service.checkIns.length, equals(initialCount + 1));
      expect(service.checkIns.first['similarityScore'], equals(99.4));
      expect(service.checkIns.first['livenessVerified'], isTrue);
      expect(notified, isTrue);
    });

    test('triggerSosAlert prepends emergency broadcast log entry', () {
      service.triggerSosAlert();
      expect(service.trackedLogs.first.tags.contains('CRITICAL'), isTrue);
      expect(service.trackedLogs.first.tags.contains('SOS BROADCAST'), isTrue);
    });

    test('updateTrackedProfile updates profile and notifies listeners', () {
      var notified = false;
      service.addListener(() => notified = true);

      service.updateTrackedProfile(
        name: 'Alexander Cross',
        phone: '+1 (512) 555-9988',
      );

      expect(service.trackedUserName, equals('Alexander Cross'));
      expect(service.trackedUserPhone, equals('+1 (512) 555-9988'));
      expect(notified, isTrue);
    });

    test('syncOfflineQueue marks offline queue as synchronized', () async {
      service.pendingOfflineSyncCount = 5;
      var notified = false;
      service.addListener(() => notified = true);

      await service.syncOfflineQueue();
      expect(service.pendingOfflineSyncCount, equals(0));
      expect(notified, isTrue);
    });

    test('addGeneratedReport prepends certified report to caseReports list', () {
      var notified = false;
      service.addListener(() => notified = true);

      final initialCount = service.caseReports.length;
      service.addGeneratedReport(
        title: 'Bail Compliance Summary Oct 2026',
        format: 'PDF (SHA-256 Sealed)',
      );

      expect(service.caseReports.length, equals(initialCount + 1));
      expect(service.caseReports.first.title, equals('Bail Compliance Summary Oct 2026'));
      expect(notified, isTrue);
    });
  });
}
