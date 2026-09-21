import '../../../../../core/utils/app_exports.dart';
import '../../../dashboard/presentation/widgets/tracker_surface.dart';
import '../../../home/presentation/widgets/tracker_home_header.dart';

class TrackerCasesView extends StatelessWidget {
  const TrackerCasesView(
      {super.key,
      this.onCaseSelected,
      this.onSosDetails,
      this.onNotifications});
  final ValueChanged<String>? onCaseSelected;
  final VoidCallback? onSosDetails;
  final VoidCallback? onNotifications;

  @override
  Widget build(BuildContext context) => ListView(
        key: const PageStorageKey('tracker-cases'),
        padding: AppInsets.all(24),
        children: [
          TrackerHomeHeader(
              name: AppStrings.trackedSettingsProfileName,
              onNotifications: onNotifications),
          24.ph,
          const TrackerSectionTitle('Cases'),
          24.ph,
          _CaseCard(
              id: '#2024-001',
              title: 'Martinez Monitoring Case',
              status: 'Active',
              statusColor: AppColors.trackerOnlineGreen,
              legalHold: true,
              people: const [('DC', 'Daniel Chen'), ('SM', 'Sarah Martinez')],
              evidence: '48 evidence items',
              date: 'Jan 15, 2024',
              onTap: onCaseSelected == null
                  ? null
                  : () => onCaseSelected!('#2024-001')),
          10.ph,
          _CaseCard(
              id: '#2024-003',
              title: 'Wilson Location Dispute',
              status: 'Under Review',
              statusColor: const Color(0xff51a2ff),
              people: const [('JW', 'James Wilson')],
              evidence: '23 evidence items',
              date: 'Mar 8, 2024',
              onTap: onCaseSelected == null
                  ? null
                  : () => onCaseSelected!('#2024-003')),
          10.ph,
          _CaseCard(
              id: '#2023-089',
              title: 'Archived: Davis Compliance',
              status: 'ARCHIVED',
              statusColor: Colors.white,
              people: const [('ED', 'Emma Davis')],
              evidence: '156 evidence items',
              date: 'Closed Nov. 2023',
              onTap: onCaseSelected == null
                  ? null
                  : () => onCaseSelected!('#2023-089')),
          10.ph,
          GestureDetector(
            onTap: onSosDetails,
            child: TrackerSurface(
              borderColor: const Color(0xffd4183d),
              child: Row(children: [
                Container(
                    width: 44.w,
                    height: 44.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xff321f67).withValues(alpha: .5)),
                    child: Text('LP',
                        style: context.bodyMediumStyle
                            ?.copyWith(fontSize: 14.sp, color: Colors.white))),
                12.pw,
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Lisa Park',
                          style: context.bodyMediumStyle?.copyWith(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                      4.ph,
                      Row(children: [
                        SvgPicture.asset(AppAssetsSvg.trackerUserLocation,
                            width: 12.w,
                            height: 12.w,
                            colorFilter: const ColorFilter.mode(
                                Color(0xff8ba9a3), BlendMode.srcIn)),
                        4.pw,
                        Expanded(
                            child: Text('Financial District',
                                style: context.bodySmallStyle?.copyWith(
                                    fontSize: 12.sp,
                                    color: const Color(0xff8ba9a3))))
                      ]),
                      3.ph,
                      Text('30 sec ago',
                          style: context.bodySmallStyle?.copyWith(
                              fontSize: 12.sp, color: const Color(0xff8ba9a3))),
                    ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  const TrackerBadge('SOS!', background: Color(0xffd4183d)),
                  6.ph,
                  const TrackerBadge('VERIFIED',
                      color: AppColors.trackerOnlineGreen),
                  8.ph,
                  SvgPicture.asset(AppAssetsSvg.trackerAlertChevron,
                      width: 16.w, height: 16.w),
                ]),
              ]),
            ),
          ),
        ],
      );
}

class _CaseCard extends StatelessWidget {
  const _CaseCard(
      {required this.id,
      required this.title,
      required this.status,
      required this.statusColor,
      required this.people,
      required this.evidence,
      required this.date,
      this.legalHold = false,
      this.onTap});
  final String id, title, status, evidence, date;
  final Color statusColor;
  final List<(String, String)> people;
  final bool legalHold;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: TrackerSurface(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                  Text(id,
                      style: context.bodySmallStyle?.copyWith(
                          fontSize: 11.sp,
                          fontFamily: 'monospace',
                          color: Colors.white)),
                  TrackerBadge(status, color: statusColor),
                  if (legalHold)
                    const TrackerBadge('LEGAL HOLD',
                        color: AppColors.trackerAmber,
                        background: Color(0xff513b22)),
                ])),
            8.pw,
            SvgPicture.asset(AppAssetsSvg.trackerAlertChevron,
                width: 16.w,
                height: 16.w,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          ]),
          10.ph,
          Text(title,
              style: context.titleMediumStyle?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.viewerSignInText)),
          12.ph,
          Wrap(spacing: 6.w, runSpacing: 6.h, children: [
            for (final (initials, name) in people)
              Container(
                padding: AppInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .1),
                    borderRadius: 100.circular),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      width: 16.w,
                      height: 16.w,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xff432980)),
                      child: Text(initials,
                          style: context.bodySmallStyle?.copyWith(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white))),
                  4.pw,
                  Text(name,
                      style: context.bodySmallStyle?.copyWith(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)),
                ]),
              )
          ]),
          12.ph,
          Text('$evidence    ·    $date',
              style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white)),
        ])),
      );
}
