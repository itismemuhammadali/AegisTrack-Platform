import '../../../../../core/utils/app_exports.dart';
import '../../../authentication/presentation/widgets/tracked_subscription_scaffold.dart';
import '../../domain/entities/tracked_check_in_entity.dart';
import '../widgets/tracked_check_in_card.dart';

class TrackedCheckInsView extends StatelessWidget {
  const TrackedCheckInsView({super.key, this.onStart});

  final VoidCallback? onStart;

  // replace with the check-in schedule from the tracking service.
  static const _upcoming = [
    TrackedCheckInEntity(
      time: '2:00 PM',
      day: 'Today',
      detail: 'Daily · In 3h 30m',
      status: TrackedCheckInStatus.upcoming,
    ),
    TrackedCheckInEntity(
      time: '6:00 PM',
      day: 'Today',
      detail: 'Daily · In 7h 30m',
      status: TrackedCheckInStatus.upcoming,
    ),
  ];

  static const _history = [
    TrackedCheckInEntity(
      time: '9:00 AM',
      day: 'Yesterday',
      detail: 'Daily',
      status: TrackedCheckInStatus.completed,
    ),
    TrackedCheckInEntity(
      time: '3:00 PM',
      day: 'Yesterday',
      detail: 'Daily',
      status: TrackedCheckInStatus.missed,
    ),
    TrackedCheckInEntity(
      time: '7:00 AM',
      day: '2 days ago',
      detail: 'Daily',
      status: TrackedCheckInStatus.completed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final sectionStyle = context.bodySmallStyle?.copyWith(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
      letterSpacing: 0.3,
      color: AppColors.primaryWhite,
    );

    return TrackedSubscriptionScaffold(
      title: AppStrings.checkInsTitle,
      subtitle: AppStrings.checkInsSubtitle,
      subtitleColor: AppColors.primaryWhite.withValues(alpha: 0.6),
      child: ListView(
        padding: AppInsets.only(left: 24, right: 24, top: 16, bottom: 24),
        children: [
          _DueNowCard(onStart: onStart),
          24.ph,
          Text(AppStrings.checkInsUpcoming.toUpperCase(), style: sectionStyle),
          for (final checkIn in _upcoming) ...[
            10.ph,
            TrackedCheckInCard(checkIn: checkIn),
          ],
          24.ph,
          Text(AppStrings.checkInsHistory.toUpperCase(), style: sectionStyle),
          for (final checkIn in _history) ...[
            if (checkIn == _history.first) 16.ph else 10.ph,
            TrackedCheckInCard(checkIn: checkIn),
          ],
          24.ph,
          const _WeekSummaryCard(),
        ],
      ),
    );
  }
}

class _DueNowCard extends StatelessWidget {
  const _DueNowCard({this.onStart});

  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    const amber = AppColors.trackedCheckInAmber;

    return Container(
      padding: AppInsets.all(21),
      decoration: BoxDecoration(
        color: amber.withValues(alpha: 0.1),
        borderRadius: 16.circular,
        border: Border.all(color: amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: amber.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              AppAssetsSvg.trackedCheckInDue,
              width: 20.w,
              height: 20.w,
            ),
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.checkInsDueNow,
                  style: context.bodyMediumStyle?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    height: 20 / 14,
                    color: AppColors.primaryWhite,
                  ),
                ),
                Text(
                  AppStrings.checkInsDueSchedule,
                  style: context.bodySmallStyle?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    height: 16 / 12,
                    color: amber,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onStart,
            child: Container(
              padding: AppInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: amber,
                borderRadius: 18.circular,
              ),
              child: Text(
                AppStrings.checkInsStart,
                style: context.bodySmallStyle?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  height: 16 / 12,
                  color: AppColors.trackedCheckInStartText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekSummaryCard extends StatelessWidget {
  const _WeekSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withValues(alpha: 0.05),
        borderRadius: 16.circular,
        border: Border.all(
          color: AppColors.primaryWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AppAssetsSvg.trackedCheckInCalendar,
                width: 16.w,
                height: 16.w,
              ),
              8.pw,
              Text(
                AppStrings.checkInsThisWeek,
                style: context.bodyMediumStyle?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 20 / 14,
                  color: AppColors.primaryWhite,
                ),
              ),
            ],
          ),
          10.ph,
          Row(
            children: [
              for (final (value, label, color) in const [
                (
                  '8',
                  AppStrings.checkInsCompleted,
                  AppColors.trackedZoneAllowedGreen
                ),
                ('1', AppStrings.checkInsMissed, AppColors.trackedSosRed),
                ('89%', AppStrings.checkInsRate, AppColors.primaryWhite),
              ])
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        value,
                        style: context.titleLargeStyle?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          height: 28 / 20,
                          color: color,
                        ),
                      ),
                      Text(
                        label,
                        style: context.bodySmallStyle?.copyWith(
                          fontSize: 12.sp,
                          height: 16 / 12,
                          color: AppColors.hintGray,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
