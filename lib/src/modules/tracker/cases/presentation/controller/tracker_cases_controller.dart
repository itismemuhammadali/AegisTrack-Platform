import '../../../../../core/utils/app_exports.dart';
import '../../domain/entities/tracker_case_entity.dart';

/// Figma sample records; replace with the viewer case API.
class TrackerCasesController extends ChangeNotifier with Buffers {
  final List<TrackerCaseEntity> cases = const [
    TrackerCaseEntity(
      id: '#2024-001',
      title: 'Martinez Monitoring Case',
      status: AppStrings.trackerCaseStatusActive,
      statusColor: AppColors.trackerOnlineGreen,
      legalHold: true,
      people: [
        TrackerCasePersonEntity(initials: 'DC', name: 'Daniel Chen'),
        TrackerCasePersonEntity(initials: 'SM', name: 'Sarah Martinez'),
      ],
      evidence: '48 evidence items',
      date: 'Jan 15, 2024',
    ),
    TrackerCaseEntity(
      id: '#2024-003',
      title: 'Wilson Location Dispute',
      status: AppStrings.trackerCaseStatusUnderReview,
      statusColor: AppColors.trackerInfoBlue,
      people: [TrackerCasePersonEntity(initials: 'JW', name: 'James Wilson')],
      evidence: '23 evidence items',
      date: 'Mar 8, 2024',
    ),
    TrackerCaseEntity(
      id: '#2023-089',
      title: 'Archived: Davis Compliance',
      status: AppStrings.trackerCaseStatusArchived,
      statusColor: AppColors.primaryWhite,
      people: [TrackerCasePersonEntity(initials: 'ED', name: 'Emma Davis')],
      evidence: '156 evidence items',
      date: 'Closed Nov. 2023',
    ),
  ];

  final String sosName = 'Lisa Park';
  final String sosInitials = 'LP';
  final String sosLocation = 'Financial District';
  final String sosTime = '30 sec ago';
}

final trackerCasesControllerProvider =
    ChangeNotifierProvider.autoDispose<TrackerCasesController>(
  (ref) => TrackerCasesController(),
);
